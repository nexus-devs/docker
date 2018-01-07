#!/bin/sh
sudo true

# Docker setup
bash ./install.sh

# Windows adjustments
echo "PATH='$HOME/bin:$HOME/.local/bin:$PATH'" >> ~/.bashrc
echo "PATH='$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin'" >> ~/.bashrc
echo "export DOCKER_HOST='tcp://0.0.0.0:2375'" >> ~/.bashrc
source ~/.bashrc