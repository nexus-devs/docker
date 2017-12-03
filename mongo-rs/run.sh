#!/bin/bash
# Create local bridge network
[ ! "$(docker network ls | grep mongo-rs)" ] && docker network create mongo-rs


# Generate keyfile for mongodb replica set internal authentication
# (won't overwrite existing file)
if [ ! -f config/keyfile ]; then
  make keyfile
fi


# Run members locally or add them to hosts
count=0
add_hosts=""
rs_initiate=false

# Check for remote members and add to hosts
while read line || [ -n "$line" ]; do
  host="${line%% *}"
  name="${line##* }"

  if [ "$host" == "${host%"127.0.0.1"*}" ]; then
    add_hosts+="--add-host ${name}:${host%%:*} "
  fi
done < config/members

# Check for local members and start locally
while read line || [ -n "$line" ]; do
  host="${line%% *}"
  name="${line##* }"
  port=${host##*:}

  if [ "$host" != "${host%"127.0.0.1"*}" ]; then
    echo ""

    # Distinguish primary from secondary. Primary will initiate the replica set
    # and wait for secondaries to become available first.
    [[ $count == 0 ]] && mtype="PRIMARY" || mtype="SECONDARY"
    echo "* Starting ${name} on ${host} (${mtype})"
    docker run --name $name \
               -v $name:/data/db \
               --env-file config/env \
               -d \
               -p $port:27017 \
               --net mongo-rs \
               $add_hosts \
               $([ mtype == "SECONDARY" ] && echo "--env IS_SECONDARY=true" || echo "") \
               $@ \
               mongo-rs
  fi
  let "count++"
done < config/members
echo ""