#!/bin/sh
pwd=`cat /run/secrets/mongo-admin-pwd`
mkdir -p /data/backups/previous

# Always keep a second backup
if [ -d "/data/backups/latest" ]; then
  rm -rf /data/backups/previous/*
  mv /data/backups/latest/* /data/backups/previous
fi

mongodump \
  -h localhost \
  -u admin \
  -p $pwd \
  --gzip \
  --oplog \
  -o /data/backups/latest