#!/bin/bash
# Create local bridge network
[ ! "$(docker network ls | grep nexus-bridge)" ] && docker network create nexus-bridge

# Run container
echo ""
echo "* Starting Nexus-Stats on"
docker run -d --name nexus-stats -p 80:80 -p 443:443 -p 3010:3010 -p 3020:3020 -p 3030:3030 --net nexus-bridge $@ nexus-stats
echo ""