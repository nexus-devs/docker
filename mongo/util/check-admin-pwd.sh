#!/bin/bash
# Generate keyfile for mongodb replica set internal authentication
if [ ! "$(docker secret ls | grep mongo-admin-pwd)" ]; then
  echo ""
  echo "* Generating admin password for mongodb."
  make pass
  echo "* Admin password generated as docker secret 'mongo-admin-pwd'"
  echo ""
fi