#!/bin/bash
# Generate user credentials for cubic nodes
for image in "$@"
  do
    if [ ! "$(docker secret ls | grep nexus-$image-key)" ]; then
    echo ""
    echo "* Generating user credentials for $image."
    pwgen -s 64 1 > nexus-$image-key
    pwgen -s 64 1 > nexus-$image-secret
  	docker secret create nexus-$image-key nexus-$image-key
    docker secret create nexus-$image-secret nexus-$image-secret
  	rm nexus-$image-key nexus-$image-secret
    echo "* Credentials generated as docker secret 'nexus-$image-key' and 'nexus-$image-secret'"
    echo ""
  fi
done
