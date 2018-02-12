#!/bin/bash
# Init swarm
docker swarm init


# Create overlay networks
if [ ! "$(docker network ls | grep nexus_app)" ]; then
  docker network create --driver overlay nexus_app
fi
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


# Build target stack docker images and docker-compose file
[[ $1 = --ci ]] && stack="nexus_ci" || stack="nexus"

# Development
if [[ $1 == '--dev' ]]; then
  make dev
  docker-compose \
    -f compose/app-base.yml \
    -f compose/app-dev.yml \
    config > compose/$stack.yml

  # Allow attaching bind mount of the nexus repo to our dev container for easy
  # file editing on the host machine
  sed -i "/VOLUME PLACEHOLDER/c\      - $2:/app/nexus-stats" compose/$stack.yml

# Continuous integration
elif [[ $1 == '--ci' ]]; then
  make cicd
  docker-compose \
    -f compose/ci.yml \
    config > compose/$stack.yml

# Production
else
  if [[ ! $1 == '--skip-build' ]]; then
    make prod
  fi
  docker-compose \
    -f compose/app-base.yml \
    -f compose/app-prod.yml \
    config > compose/$stack.yml
fi


# Deploy selected stack
docker stack deploy --prune --compose-file compose/$stack.yml $stack


# Run watchdog to propagate file changes from the repo to our container.
# Only necessary on windows due to the nature of the filesystem.
if [[ $1 == '--dev' && \
      ${DOCKER_OS} == 'Windows' && \
      ! "$(jobs | grep docker-volume-watcher)"  ]]; then
  sleep 30
  docker-volume-watcher nexus_dev* /view &
fi


# Automatically log dev container
if [[ $1 == '--dev' ]]; then
  docker service logs nexus_dev -f
fi