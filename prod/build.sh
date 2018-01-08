#!/bin/bash
for image in "$@"
do
  # Rename custom config to blitz.config.js during build so Docker can just copy
  mv "config/$image.js" "config/blitz.config.js"
  docker build -t 127.0.0.1:5000/nexus-$image .
  mv "config/blitz.config.js" "config/$image.js"

  # Create credentials for core workers
  if [[ $image == *"core"* ]]; then
    bash util/check-credentials.sh $image
  fi

  # Push to ingress registry
  docker push 127.0.0.1:5000/nexus-$image
done