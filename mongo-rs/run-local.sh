#!/bin/sh
# Quickstart script for 3 local instances
bash run.sh '--net=host' '-p 28017:27017' '--env PORT=28017' '--env IS_SECONDARY=true' '--name rs1'
bash run.sh '--net=host' '-p 29017:27017' '--env PORT=29017' '--env IS_SECONDARY=true' '--name rs2'
sleep 20 # TODO: should actually wait until secondaries are up
bash run.sh '--net=host' # Master