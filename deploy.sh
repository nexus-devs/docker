#!/bin/bash
# Init swarm
docker swarm init

# Create overlay networks
if [ ! "$(docker network ls | grep nexus_app)" ]; then
  docker network create --driver overlay nexus_app
fi

# Create private image registry on our swarm
if [ ! "$(docker service ls | grep nexus_registry)" ]; then
  docker service create -d \
    --name nexus_registry \
    -p 5000:5000 \
    --mount type=volume,source=nexus-registry,destination=/var/lib/registry,volume-driver=local \
    registry:latest
fi

# Build images and push to our registry
make images

# Merge dev or prod file with base compose
if [[ $1 == '--dev' ]]; then
  docker-compose -f docker-compose.yml -f docker-compose.dev.yml config > docker-compose.stack.yml
  sed -i "/VOLUME PLACEHOLDER/c\      - $2:/app/nexus-stats" docker-compose.stack.yml
else
  docker-compose -f docker-compose.yml -f docker-compose.prod.yml config > docker-compose.stack.yml
fi

# Deploy
docker stack deploy --prune --compose-file docker-compose.stack.yml nexus