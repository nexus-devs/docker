#!/bin/sh
pwd=cat /run/secrets/mongo-admin-pwd
mongodump -h localhost -u admin -p $pwd --gzip --oplog -o /data/backups/latest