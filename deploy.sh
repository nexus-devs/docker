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
  docker-compose -f compose/base.yml -f compose/dev.yml config > compose/stack.yml
  sed -i "/VOLUME PLACEHOLDER/c\      - $2:/app/nexus-stats" compose/stack.yml
elif [[ $1 == '--ci' ]]; then
  docker-compose -f compose/base.yml -f compose/ci.yml config > compose/stack.yml
else
  docker-compose -f compose/base.yml -f compose/prod.yml config > compose/stack.yml
fi

# Deploy
docker stack deploy --prune --compose-file compose/stack.yml nexus