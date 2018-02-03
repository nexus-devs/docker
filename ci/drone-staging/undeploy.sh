#!/bin/sh
docker stack rm nexus_staging
sleep 20
docker rm $(docker ps -a -q)