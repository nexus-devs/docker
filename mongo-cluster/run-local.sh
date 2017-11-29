#!/bin/sh
# Quickstart script for 3 local instances
bash run.sh '--net=host' '-p 28017:28017' '--env DB_PORT=28017' '--env DB_SLAVE=true' '--name rs1'
bash run.sh '--net=host' '-p 29017:29017' '--env DB_PORT=29017' '--env DB_SLAVE=true' '--name rs2'
sleep 20
bash run.sh '--net=host' '--name rs0' # Master