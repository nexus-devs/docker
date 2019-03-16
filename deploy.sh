#!/bin/bash
OPTIONS=d:bls
LONGOPTIONS=dev:,build,local,staging
skip=true # Skip build by default unless changed in args
registry=nexusstats # push to dockerhub by default

# -temporarily store output to be able to check for errors
# -e.g. use “--options” parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
  # e.g. $? == 1
  #  then getopt has complained about wrong arguments to stdout
  exit 2
fi

# Read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"
while true; do
  case "$1" in
    -d|--dev)
      dev=true
      dev_path="$2"
      shift 2
      ;;
    -l|--local)
      local=true
      skip=false
      registry=127.0.0.1:5000
      shift
      ;;
    -b|--build)
      skip=false
      shift
      ;;
    -s|--staging)
      staging=true
      shift
      ;;
    --)
      shift
      break
      ;;
  esac
done


# Init swarm
docker swarm init

# Create private image registry on our swarm
if [[ $local == true ]] && [ ! "$(docker service ls | grep registry)" ]; then
  docker service create -d \
    --name registry \
    -p 5000:5000 \
    --mount type=volume,source=registry,destination=/var/lib/registry,volume-driver=local \
    registry:latest
fi

# Use docker-compose pointing to local registry when --local flag is passed
if [[ $local == true ]]; then
  compose_base=compose/local/app-base.yml
  compose_dev=compose/local/app-dev.yml
  compose_prod=compose/local/app-prod.yml
  compose_staging=compose/local/app-staging.yml
  compose_merged=compose/local/app.yml
else
  compose_base=compose/app-base.yml
  compose_dev=compose/app-dev.yml
  compose_prod=compose/app-prod.yml
  compose_staging=compose/app-staging.yml
  compose_merged=compose/app.yml
fi

# Development
if [[ $dev == true ]]; then
  if [[ $skip == false ]]; then
    make dev registry=$registry
  else
    make dev-deps
  fi
  docker-compose \
    -f $compose_base \
    -f $compose_dev \
    config > $compose_merged

  # Allow attaching bind mount of the nexus repo to our dev container for easy
  # file editing on the host machine
  sed -i "/VOLUME PLACEHOLDER/c\      - $dev_path:/app/nexus-stats" $compose_merged

# Staging server
elif [[ $staging == true ]]; then
  if [[ $skip == false ]]; then
    make staging registry=$registry
  else
    make prod-deps
  fi
  cp ./app/prod/prelaunch.js /opt/debug/prelaunch.js
  docker-compose \
    -f $compose_base \
    -f $compose_prod \
    -f $compose_staging \
    config > $compose_merged

# Production
else
  if [[ $skip == false ]]; then
    make prod registry=$registry
  else
    make prod-deps
  fi
  docker-compose \
    -f $compose_base \
    -f $compose_prod \
    config > $compose_merged
fi

# Delete old containers (Docker sometimes just doesn't delete them)
docker system prune --force

# Deploy selected stack
docker stack deploy --prune --compose-file $compose_merged nexus

# Automatically log dev container
if [[ $dev == true ]]; then
  # Run watchdog to propagate file changes from the repo to our container.
  # Only necessary on windows due to the nature of the filesystem.
  if [[ $dev == true && ${DOCKER_OS} == 'Windows' && ! $(ps -ef) =~ 'docker-volume-watcher'  ]]; then
    docker-volume-watcher nexus_dev* /ui &
  fi

  # Just logging
  docker service logs nexus_dev -f --raw
fi
