#!/bin/bash
# Get keyfile from mounted secret (must be copied to location with write perms)
cp /run/secrets/mongo-keyfile /data/config/keyfile
chmod 400 /data/config/keyfile

# Run mongod without replica set, so it resets any existing config
mongod --fork --logpath /data/fork.log
mongo local --eval "db.dropDatabase()"
mongod --shutdown

# Run http listener for rs.initiate() calls and admin creation
nohup python3 -u /listener.py > ~/py.log &

# Run replica mongod instance
mongod --replSet nexus --keyFile /data/config/keyfile --bind_ip 0.0.0.0
