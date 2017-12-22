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
    config = { '_id': 'nexus', 'members': [] }

    for i in range(len(hosts)):
        config['members'].append({ '_id': i, 'host': hosts[i] + ':27017' })
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


def rs_reconfig(config):
    mongo = pymongo.MongoClient(replicaset='nexus', username='admin',
                                password=pwd, authSource='admin')
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
    config = get_rs_config(hosts_current)

    print('* Checking for new hosts..')
    print(hosts_current)

    # If new hosts detected: rs.reconfig() or rs.initiate() with available hosts
    if len(added):
        if len(active):
            print('> Found new hosts! Adding..')
            rs_reconfig(config)
            print('> Reconfigured replica set. Killing listeners on new nodes..')

        # Send rs.initiate() to single container's listener, tell the others to
        # shutdown without initializing.
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