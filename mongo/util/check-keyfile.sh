#!/bin/bash
# Generate keyfile for mongodb replica set internal authentication
if [ ! "$(docker secret ls | grep mongo-keyfile)" ]; then
  echo ""
  echo "* Generating keyfile for mongodb internal authentication."
  make keyfile
  echo "* Keyfile generated as docker secret 'mongo-keyfile'"
  echo ""
fi