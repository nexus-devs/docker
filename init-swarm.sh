#!/bin/bash
# Init swarm
docker swarm init

# Create overlay networks
docker network create --driver overlay nexus_app

# Create image registry on our swarm
docker service create -d \
  --name nexus_registry \
  -p 5000:5000 \
  --mount type=volume,source=nexus-registry,destination=/var/lib/registry,volume-driver=local \
  registry:latest

# Build images and push to our registry
make images

# Deploy nexus stack
if [ $1 == '--dev' ]; then
  # sed -i "/<bind volume placeholder>/c\			- $2:/destination/path"
  docker stack deploy --compose-file docker-compose-dev.yml nexus
else
  docker stack deploy --compose-file docker-compose.yml nexus
fi