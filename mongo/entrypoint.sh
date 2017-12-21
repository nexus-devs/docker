#!/bin/sh
# Get keyfile from mounted secret (must be copied to location with write perms)
cp /run/secrets/mongo-keyfile /data/config/keyfile
chmod 400 /data/config/keyfile

# Run http listener for rs.initiate() calls and admin creation
nohup python3 /listener.py &

# Run replica mongod instance
mongod --replSet nexus-rs --keyFile /data/config/keyfile --auth