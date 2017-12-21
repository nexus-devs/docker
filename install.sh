#!/bin/sh
# Docker setup
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install
apt-get update -y
apt-get install -y docker-ce
apt-get install -y docker-compose

# Container requirements
apt-get install -y pwgen