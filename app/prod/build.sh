#!/bin/bash
build () {
  # Rename custom config to blitz.config.js during build so Docker can just copy
  mv "config/$1/$2.config.js" "config/blitz.config.js"
  docker build -t 127.0.0.1:5000/nexus-$2-$1 .
  mv "config/blitz.config.js" "config/$1/$2.config.js"

  # Create credentials for core workers
  if [[ $2 == "core" ]]; then
    bash util/check-credentials.sh $2-$1
  fi

  # Push to ingress registry
  docker push 127.0.0.1:5000/nexus-$2-$1
}

for image in "$@"
do
  build $image api
  build $image core
done