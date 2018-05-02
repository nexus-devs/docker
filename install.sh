#!/bin/sh
sudo true

# Docker setup
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Docker CE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce

# Docker compose
wget -O - https://bit.ly/docker-install | bash

# Container requirements
apt-get install -y pwgen
apt-get install -y build-essential