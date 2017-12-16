#!/bin/bash
# Generate keyfile for mongodb replica set internal authentication
# (won't overwrite existing file)
if [ ! -f config/keyfile ]; then
  echo ""
  echo "* Generating keyfile for mongodb internal authentication."
  echo "* You'll want to copy this file to all machines of the replica set."
  make keyfile
  echo "* Keyfile generated at /mongo-rs/config/keyfile"
  echo ""
fi