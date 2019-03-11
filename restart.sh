#!/bin/bash
# Restarts a single container on a running stack and logs further output.
docker service scale $1=0 && docker service scale $1=1 && docker service logs $1