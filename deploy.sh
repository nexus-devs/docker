#!/bin/sh
# Deploy nexus stack
if [ $1 == '--dev' ]; then

  # Merge dev and main docker-compose, then add bind mount for nexus repo
  docker-compose -f docker-compose.yml -f docker-compose.dev.yml config > docker-compose.stack.yml
  sed -i "/VOLUME PLACEHOLDER/c\      - $2:/app/nexus-stats" docker-compose.stack.yml

  docker stack deploy --compose-file docker-compose.stack.yml nexus
else
  docker stack deploy --compose-file docker-compose.yml nexus
fi