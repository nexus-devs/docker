#!/bin/bash
# Create local bridge network
[ ! "$(docker network ls | grep mongo-rs)" ] && docker network create mongo-rs


# Generate keyfile for mongodb replica set internal authentication
# (won't overwrite existing file)
if [ ! -f config/keyfile ]; then
  make keyfile
fi


# Figure out which hosts are local, so we start them here
count=0

# Read replica set members
while read line || [ -n "$line" ]; do
  if [ "$line" != "${line%"127.0.0.1"*}" ]; then
    host="${line%% *}"
    name="${line##* }"

    # First member considered primary => we need to initiate the replica set here
    if [ $count == 0 ]; then
      rs_initiate=true
      rs_primary_host=$host
      rs_primary_name=$name

    # Run the secondary member first
    else
      echo ""
      echo "* Starting ${name} on ${host} (SECONDARY)"
      port=${host##*:}
      docker run --name $name --env-file config/env -d -p $port:27017 --env IS_SECONDARY=true --net mongo-rs $@ mongo-rs
    fi
  fi
  let "count++"
done < config/members
echo ""


# Found that replica set should be initiated here
if [ $rs_initiate == true ]; then
  echo "* Starting ${rs_primary_name} on ${rs_primary_host} (PRIMARY)"

  # Start mongod instance which initiates the replica set
  port=${rs_primary_host##*:}
  docker run --name $rs_primary_name --env-file config/env -d -p $port:27017 --net mongo-rs $@ mongo-rs
  echo ""
fi