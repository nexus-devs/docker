#!/bin/bash
# Init swarm
docker swarm init

# Create overlay networks
docker network create --driver overlay nexus-app

# Create image registry on our swarm
docker service create -d \
  --name nexus-registry \
  -p 5000:5000 \
  --mount type=volume,source=nexus-registry,destination=/var/lib/registry,volume-driver=local \
  registry:latest

# Build images and push to our registry
make images