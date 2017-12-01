#!/bin/bash
# Figure out which hosts are local, so we start them here
id=0

# Read replica set members
while read line || [ -n "$line" ]; do
  if [ "$line" != "${line%"127.0.0.1"*}" ]; then
    let "id++"
    host="${line%% *}"

    # Primary shard is local => we need to initiate the replica set here
    if [ $id == 1 ]; then
      rs_initiate=true

    # Run the secondary member first
    else
      docker run --name "rs${id}" --env-file ./config/env -d -p ${host##*:}:27017 --env IS_SECONDARY=true mongo-rs
    fi
  fi
done < ./config/members


# Found that replica set should be initiated here
if [ -z $rs_initiate ]; then
  sleep 10 #TODO: should actually wait until secondaries are up
  docker run --name rs0 --env-file ./config/env -d -p 27017:27017 mongo-rs
fi