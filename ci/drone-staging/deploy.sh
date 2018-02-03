#!/bin/sh
# Build relevant docker images
cd /docker
make images
cd app/prod
make staging
make image

# Deploy stack
cd /docker
bash deploy.sh --skip-build