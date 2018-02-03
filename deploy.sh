#!/bin/bash
# Init swarm
docker swarm init

# Create overlay networks
if [ ! "$(docker network ls | grep nexus_app)" ]; then
  docker network create --driver overlay nexus_app
fi
# Create overlay networks
if [ ! "$(docker network ls | grep nexus_ci)" ]; then
  docker network create --driver overlay nexus_ci
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
if [[ ! $1 == '--skip-build' ]]; then
  make images
fi

# Merge dev or prod file with base compose
[[ $1 = --ci ]] && stack="nexus_ci" || stack="nexus"

if [[ $1 == '--dev' ]]; then
  docker-compose \
    -f compose/app-base.yml \
    -f compose/app-dev.yml \
    config > compose/$stack.yml
  # Add option to attach bind mount of the nexus repo to our dev container
  sed -i "/VOLUME PLACEHOLDER/c\      - $2:/app/nexus-stats" compose/$stack.yml
elif [[ $1 == '--ci' ]]; then
  docker-compose \
    -f compose/ci.yml \
    config > compose/$stack.yml
else
  docker-compose \
    -f compose/app-base.yml \
    -f compose/app-prod.yml \
    config > compose/$stack.yml
fi

# Deploy
docker stack deploy --prune --compose-file compose/$stack.yml $stack