#!/bin/sh
sudo true

# Docker setup
if [ -x "$(command -v docker)" ]; then
  wget -O - https://bit.ly/docker-install | bash
fi

# Build requirements
if [ -x "$(command -v pwgen)"]; then
  apt-get install -y pwgen
fi

if [ -x "$(command -v make)"]; then
  apt-get install -y build-essential
fi
