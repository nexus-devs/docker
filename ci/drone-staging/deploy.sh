#!/bin/sh
# Build relevant docker images
cd /docker
make images
cd app/prod
make staging
make image

# Deploy stack
cd /docker
docker-compose \
  -f compose/app-base.yml \
  -f compose/app-prod.yml \
  config > compose/nexus_staging.yml
docker stack deploy --prune --compose-file compose/nexus_staging.yml nexus_staging