#!/bin/sh
# Run first mongod instance without replset flag to set database admins on primary
if [ -z $IS_SECONDARY ]; then
  mongod --fork --logpath /data/logs/mongod.log
  until nc -z localhost 27017
  do
    sleep 1
  done

  mongo "admin" <<-EOJS
    db.createUser({
      user: "admin",
      pwd: "$ADMIN_PWD",
      roles: [{ role: "root", db: "admin"}]
    })
    db.createUser({
      user: "clusterAdmin",
      pwd: "$CLUSTER_PWD",
      roles: [{ role: "clusterAdmin", db: "admin" }]
    })
    db.shutdownServer()
	EOJS
fi

# Run mongod main instance
mongod --fork --logpath /data/logs/mongod.log --replSet nexus --auth --keyFile /data/config/keyfile
until nc -z localhost 27017
do
    sleep 1
done


# Set up replica cluster on primary
if [ -z $IS_SECONDARY ]; then

  # Generate replica set members from member config
  id=0

  while read line || [ -n "$line" ]; do
    host=${line##* } # last word in line (either IP or DNS record)
    members="$members{ _id: $id, host: '$host'},"
    let "id++"
  done < /data/config/members

  # Wait for last replica member to become available for connections
  until nc -z $host 27017
  do
    sleep 5
  done

  # Initiate replica set
  mongo "admin" -u clusterAdmin -p $CLUSTER_PWD --authenticationDatabase admin <<-EOJS
    rs.initiate({
      _id: "nexus",
      members: [${members%?}]
    })
	EOJS
fi

# Keep container running
while true; do sleep 1000; done