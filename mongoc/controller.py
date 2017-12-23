## Controller for handling mongo replica set member containers
#
# Quick rundown of what we do here:
# 1) get DNS records of other mongo containers on the swarm
# 2) are there new or missing hosts? => rs.reconfig() with new hosts
# 2.1) are there previously no hosts? => rs.initiate() with new hosts

import os
import time
import docker
import requests
import json
import pymongo

# Config
with open('/run/secrets/mongo-admin-pwd') as f: pwd = f.read().rstrip()
docker = docker.APIClient(base_url='unix://var/run/docker.sock')
service = os.environ['SERVICE_NAME'] or 'mongo'
version = 0
config = { '_id': 'nexus', 'version': version, 'members': [] }
hosts = []



# --------------------
# Network/DB functions
# --------------------
def get_host_names():
    containers = docker.tasks(filters = { 'service': service })
    host_names = []

    for container in containers:
        host_names.append(service + '.' + str(container['Slot']) + '.' + container['ID'])
    return host_names


def get_rs_config(hosts):
    global version
    members = list(config['members']) # clone list so we can mutate in loop

    # Remove old hosts
    for mongo in members:
        host = mongo['host'].split(':')[0]

        # Already exists => remove from new hosts
        if host in hosts:
            hosts.remove(host)
        # Got dropped => remove from config
        else:
            config['members'] = [m for m in config['members'] if m['_id'] != mongo['_id']]

    # Set new version
    version += 1
    config['version'] = version

    # Append new hosts to config
    x = len(members) - 1
    last_id = members[x]['_id'] if x >= 0 else 0
    for i in range(len(hosts)):
        config['members'].append({ '_id': last_id + i + 1, 'host': hosts[i] + ':27017' })
    return config


# Send a http request to the listener on the target mongo container to initiate
# the replica set and add the admin user. The listener will shut down once done.
def rs_initiate(target, config):
    try:
        requests.post('http://' + target + ':27027/initiate',
                      data=json.dumps({ 'target': target, 'config': config, 'secret': pwd }),
                      headers={ 'Content-Type': 'application/json' })
    except:
        pass


def rs_reconfig(target, config):
    mongo = pymongo.MongoClient(target + ':27017', replicaset='nexus',
                                username='admin', password=pwd, authSource='admin')
    mongo.admin.command('replSetReconfig', config)
    mongo.close()


# Shut down the initiation listener without initiating. This will be necessary
# for every container that we do NOT initiate on. (so basically all but one)
def kill_listeners(hosts):
    try:
        for host in hosts:
            requests.get('http://' + host + ':27027/kill')
    except:
        pass



# --------------------
# Application Logic
# --------------------
while True:
    hosts_current = get_host_names()
    added = [host for host in hosts_current if host not in hosts]
    active = [host for host in hosts_current if host not in added]

    print('* Checking for new hosts..')
    print(hosts_current)

    # If new hosts detected: rs.reconfig() or rs.initiate() with available hosts
    if len(added) or len(hosts_current) != len(hosts):
        config = get_rs_config(list(hosts_current))
        time.sleep(30) # Give container enough time to start up

        if len(active):
            print('> Found new hosts! Adding..')
            rs_reconfig(active[0], config)
            print('> Reconfigured replica set. Killing listeners on new nodes..')
        else:
            print('> First time setup, initiating on ' + added[0])
            rs_initiate(added[0], config)
            print('> Replica set initiated! Killing remaining listeners..')

        # Kill listeners of new nodes in both cases
        kill_listeners(added)
        print('> Listeners killed, replica set is now ready!')
    else:
        print('> Nothing new.')

    print(' ')
    hosts = hosts_current
    time.sleep(5) # repeat this check every 5 seconds