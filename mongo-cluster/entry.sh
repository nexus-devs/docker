#!/bin/sh
adminPwd="123456"
clusterPwd="123456"

# Docker entrypoint (pid 1), run as root
[ "$1" = "mongod" ] || exec "$@" || exit $?

# Make sure that database is owned by user mongodb
[ "$(stat -c %U /data/db)" = mongodb ] || chown -R mongodb /data/db

# Check if we already initialized our setup
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

# Create admin and cluster users if not already done
if [ "$init" ]; then
  members=""
  id=0

  # run mongod instance for init process
  mkdir /data/logs
  mongod --fork --logpath /data/logs/mongod.log
  until nc -z localhost 27017
  do
      sleep 1
  done

  # Generate replica set members from host file
  while read line; do
    host="${line##* }" # last word in line
    members="${members}{ _id: $id, host: $host}, "
    let "id++"
  done < /data/config/hosts

  # Create db admin and replica set admin, then initiate replica set
  mongo "admin" <<-EOJS
		db.createUser({
			user: "admin",
			pwd: "$adminPwd",
			roles: [{ role: "root", db: "admin")}]
		})
    db.createUser({
      user: "clusterAdmin",
      pwd: "$clusterPwd",
      roles: [{ role: "clusterAdmin", db: "admin" }]
    })
    rs.initiate({
      _id: "mongo-rs",
      members: [$members]
    })
	EOJS
fi

# Drop root privilege (no way back), exec provided command as user mongodb
cmd=exec; for i; do cmd="$cmd '$i'"; done
exec su -s /bin/sh -c "$cmd" mongodb