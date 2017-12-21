#!/bin/sh
docker service create --name nexus-mongo \
  --replicas 3 \
  -p 27017:27017 \
  --detach=false \
  --network=nexus-app \
  --secret mongo-keyfile \
  --secret mongo-admin-pwd \
  127.0.0.1:5000/mongo

docker service create --name nexus-mongoc \
  --constraint node.role==manager \
  -p 9999:9999 \
  --env SERVICE_NAME=nexus-mongo \
  --detach=false \
  --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
  --network=nexus-app \
  --secret mongo-admin-pwd \
  127.0.0.1:5000/mongoc