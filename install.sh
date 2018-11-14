#!/bin/sh
sudo true

# Docker setup
if ! type "docker-compose" > /dev/null; then
  wget -O - https://bit.ly/docker-install | bash
fi

# Build requirements
if ! type "pwgen" > /dev/null; then
  apt-get install -y pwgen
fi
if ! type "make" > /dev/null; then
  apt-get install -y build-essential
fi
