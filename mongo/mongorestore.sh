#!/bin/sh
pwd=cat /run/secrets/mongo-admin-pwd
mongorestore \
  -h localhost \
  -u admin \
  -p $pwd \
  --gzip \
  --archive \
  --oplogReplay \
  /data/backups/latest