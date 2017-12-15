#!/bin/bash
# Create local bridge network
[ ! "$(docker network ls | grep nexus-bridge)" ] && docker network create nexus-bridge

# Run container
echo ""
echo "* Starting nginx on :80 :443"
docker run -d --name nginx -v redis:/data -p 80:80 -p 443:443 --net nexus-bridge $@ nginx
echo ""