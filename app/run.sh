#!/bin/bash
# Create local bridge network
[ ! "$(docker network ls | grep nexus-bridge)" ] && docker network create nexus-bridge

# Run container
echo ""
echo "* Starting Nexus-Stats. API on :3010, Auth on :3020, Web Client on :3030"
docker run -d --name nexus-stats -p 3010:3010 -p 3020:3020 -p 3030:3030 --net nexus-bridge $@ nexus-stats
echo ""