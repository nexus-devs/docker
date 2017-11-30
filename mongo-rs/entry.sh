#!/bin/sh
# Make sure that database is owned by user mongodb
[ "$(stat -c %U /data/db)" = mongodb ] || chown -R mongodb /data/db

# Run mongod instance for init process, but forked, so we can still run the
# commands below.
mkdir /data/logs
mongod --fork --logpath /data/logs/mongod.log--replSet nexus-rs
until nc -z localhost 27017
do
    sleep 1
done

# Check if we already initialized our setup on the given volume
init=false
for path in \
  /data/db/WiredTiger \
  /data/db/journal \
  /data/db/local.0 \
  /data/db/storage.bson \
; do
  if [ -e "$path" ]; then
    init=true
    break
  fi
done

# Set up replica cluster on primary
if [ $init ] && [ -z $IS_SECONDARY ]; then
  # Extend hosts with provided replica set members
  cat "/data/config/hosts" >> "/etc/hosts"

  # Generate replica set members from host file
  id=0
  while read line; do
    # Self-reference directly with IP, so mongo doesn't do weird things like
    # not resolving the DNS to itself.
    if [ "${line}" != "${line%"127.0.0.1"*}" ]; then
      host="${line%% *}" # first word in line (IP)
    else
      host="${line##* }" # last word in line (DNS)
    fi
    echo $host
    members="${members}{ _id: $id, host: '$host'},"
    let "id++"
  done < /data/config/hosts

  # Initiate replica set
  mongo "admin" <<-EOJS
    rs.initiate({
      _id: "nexus-rs",
      members: [${members%?}]
    })
	EOJS
fi

# Add admin users. Need to wait for replSet to set up first
if [ $init ]; then
  sleep 5 # apparently mongodb needs time to set itself as primary first
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
	EOJS
fi

while true; do sleep 1000; done