#!/bin/sh
# Get keyfile from mounted secret (must be copied to location with write perms)
cp /run/secrets/mongo-keyfile /data/config/keyfile
chmod 400 /data/config/keyfile

# Run mongod instance
mongod --replSet nexus-rs --keyFile /data/config/keyfile --auth