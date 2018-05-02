#!/bin/bash
# Generate user credentials for cubic nodes
if [ ! "$(docker secret ls | grep nexus-$1-key)" ]; then
  echo ""
  echo "* Generating user credentials for $1."
  pwgen -s 64 1 > nexus-$1-key
  pwgen -s 64 1 > nexus-$1-secret
	docker secret create nexus-$1-key nexus-$1-key
  docker secret create nexus-$1-secret nexus-$1-secret
	rm nexus-$1-key nexus-$1-secret
  echo "* Credentials generated as docker secret 'nexus-$1-key' and 'nexus-$1-secret'"
  echo ""
fi