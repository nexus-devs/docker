#!/bin/bash
# Merge dev or prod file with base compose
if [[ $1 == '--dev' ]]; then
  docker-compose -f docker-compose.yml -f docker-compose.dev.yml config > docker-compose.stack.yml
  sed -i "/VOLUME PLACEHOLDER/c\      - $2:/app/nexus-stats" docker-compose.stack.yml
else
  docker-compose -f docker-compose.yml -f docker-compose.prod.yml config > docker-compose.stack.yml
fi

# Deploy
docker stack deploy --compose-file docker-compose.stack.yml nexus