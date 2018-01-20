#!/bin/sh
pwd=`cat /run/secrets/mongo-admin-pwd`

if [ -d "/data/backups/latest" ]; then
  mongorestore \
    -h localhost \
    -u admin \
    -p $pwd \
    --gzip \
    --oplogReplay \
    --writeConcern '{w:0}' \
    /data/backups/latest
fi