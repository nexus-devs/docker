#!/bin/sh
docker service create --name nexus-mongo \
  --replicas 3 \
  -p 27017:27017 \
  --detach=false \
  --network=nexus-app \
  --secret mongo-keyfile \
  127.0.0.1:5000/mongo

docker service create --name nexus-mongoc \
  --constraint node.role==manager \
  -p 9999:9999 \
  --detach=false \
  --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=bind,src=/c/dev/nexus-stats/docker/mongoc,dst=/app \
  --network=nexus-app \
  127.0.0.1:5000/mongoc