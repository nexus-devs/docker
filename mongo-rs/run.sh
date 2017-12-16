#!/bin/bash
# Create local bridge network
[ ! "$(docker network ls | grep nexus-bridge)" ] && docker network create nexus-bridge


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

  # if host DOES include 127.0.0.1 (bash is weird)
  if [ "$host" != "${host%"127.0.0.1"*}" ]; then
    echo ""

    # Distinguish primary from secondary. Primary will initiate the replica set
    # and wait for secondaries to become available first.
    [[ $count == 0 ]] && mtype="PRIMARY" || mtype="SECONDARY"
    echo "* Starting ${name} on ${host} (${mtype})"
    docker run --name $name \
      -v $name:/data/db     \
      --env-file config/env \
      -d                    \
      -p $port:27017        \
      --net nexus-bridge    \
      $add_hosts            \
      $([ $mtype == "SECONDARY" ] && echo "--env IS_SECONDARY=true" || echo "") \
      $@                    \
      mongo-rs
  fi
  let "count++"
done < config/members