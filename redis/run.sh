#!/bin/bash
# Create local bridge network
[ ! "$(docker network ls | grep nexus-bridge)" ] && docker network create nexus-bridge

# Run container
echo ""
echo "* Starting redis on 127.0.0.1:6379"
docker run -d --name redis -p 6379:6379 --net nexus-bridge $@ redis