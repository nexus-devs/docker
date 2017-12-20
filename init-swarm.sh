#!/bin/bash
# Init swarm
docker swarm init

# Create image registry on our swarm
docker service create -d \
  --name nexus_registry \
  -p 5000:5000 \
  --mount type=volume,source=nexus_registry,destination=/var/lib/registry,volume-driver=local \
  --network ingress \
  registry:latest

# Build images and push to our registry
make images