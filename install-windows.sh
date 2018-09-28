#!/bin/sh
sudo true

# Docker setup
bash ./install.sh

# Let our scripts know which environment they're in
echo "export DOCKER_OS='Windows'" >> ~/.bashrc

# Windows adjustments for docker
echo "PATH='$HOME/bin:$HOME/.local/bin:$PATH'" >> ~/.bashrc
echo "PATH='$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin'" >> ~/.bashrc
echo "export DOCKER_HOST='tcp://0.0.0.0:2375'" >> ~/.bashrc
source ~/.bashrc

# Install file watchdog to workaround an issue where file changes in bind mounts
# wouldn't propagate to the docker container.
command -v pip || { apt-get install -y python3-pip python3 }
pip install docker-bash-volume-watcher
