#!/bin/sh
sudo true

# Docker setup
command -v docker-compose || { wget -O - https://bit.ly/docker-install | bash }

# Build requirements
command -v pwgen || { apt-get install -y pwgen }
command -v make || { apt-get install -y build-essential }
