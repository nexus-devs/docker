#!/bin/sh
# Simple script to manager mongo replica sets
# https://github.com/vasetech/mongo-rs-ctrl
# Copyright (c) 2016 Vase Technologies Sdn. Bhd.

# Environment variables
SERVICE_NAME=${SERVICE_NAME:-mongo}
NETWORK_NAME=${NETWORK_NAME:-nexus-app}
REPLICA_SETS=${REPLICA_SETS:-nexus}
MONGODB_PORT=${MONGODB_PORT:-27017}

set services= master= i=
#docker_api() { curl -sN --unix-socket /run/docker.sock http:/v1.26/$*; }

get_primary() {
	services=$(nslookup tasks.$SERVICE_NAME 2>/dev/null | awk "/Addr/ {print \$4\":$MONGODB_PORT\"}")
	echo Services: $services
	for i in $services; do
		echo $i
		[ -n "$(mongo $i --quiet --eval 'rs.isMaster().setName' 2>&1)" ] \
			&& master=$(mongo $i --quiet --eval "rs.status().members.find(r=>r.state===1).name") \
			&& return
	done || mongo $i --quiet --eval "rs.initiate()" >/dev/null && master=$i \
		|| { echo Database is broken; }
}

sets() {
	mongo $master --eval "rs.isMaster().ismaster" | grep -q true || get_primary
	mongo $master --eval "rs.$1(\"$2\")" >/dev/null && echo $1 $2
}

echo -n .. Service $SERVICE_NAME is\  && docker service ps $SERVICE_NAME >/dev/null \
	&& echo UP || { echo DOWN; exit 1; }

echo -n .. Master -\  && get_primary && echo $master

echo .. Remove down replica sets
for i in $(mongo $master --quiet --eval 'rs.status().members.filter(r=>r.state===8).map(r=>r.name).join(" ")'); do
	sets remove $i
done

echo .. Add uninitialized services
for i in $services; do
	mongo $i --eval 'rs.status().members.find(r=>r.state===1).self' &>/dev/null || sets add $i
done

echo .. Listen for docker container events
docker events -f type=container -f event=start -f event=die \
	-f service=$SERVICE_NAME -f network=$NETWORK_NAME |
{
	while read -r l; do
		case $l in
			*start*) sets add $(echo $l | sed 's/.* name=\(.*\))$/\1/').$NETWORK_NAME;;
			*die*)   sets remove $(echo $l | sed 's/.* name=\(.*\))$/\1/').$NETWORK_NAME;;
		esac
	done
}