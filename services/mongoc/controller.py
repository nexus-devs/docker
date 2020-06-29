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
import replica

# Config
docker = docker.APIClient(base_url='unix://var/run/docker.sock')
services = ['mongo', 'mongo_secondary']
hosts = []
timer = time.time()


# Ping listener to figure out when container is ready
def ping(hosts):
    for host in hosts:
        resolved = False

        while not resolved:
            try:
                requests.get('http://' + host + ':27027/ping', timeout=5)
                resolved = True
            except Exception as err:
                print('Error during ping: ' + str(err))
                print('Retrying in 1s...')
                time.sleep(1)



# Get container names from docker tasks which we'll resolve to
def get_host_names():
    while True:
        try:
            containers = []
            host_names = []

            for service in services:
                containers = containers + docker.tasks(filters = { 'service': service })

            for container in containers:
                host_names.append(container['NodeID'] + '.' + container['ID'])
            return host_names
        except:
            print('Could not find services ' + services + '. Retrying in 1s...')
            time.sleep(1)



# Watch service status
while True:
    hosts_current = get_host_names()
    added = [host for host in hosts_current if host not in hosts]
    active = [host for host in hosts_current if host not in added]

    print('* Checking for new hosts..')
    print(hosts_current)

    # Check for new hosts
    if len(added) or len(hosts_current) != len(hosts):
        ping(added) # Wait for new nodes to run mongo

        # Manage replica set changes or initiate
        replica.reconfig(hosts_current, active, added)
    else:
        print('> Nothing new.')

    print(' ')
    hosts = hosts_current

    # Take backup every 24h
    if time.time() - timer >= 60 * 60 * 12:
        print('* Taking automatic backups...')
        print(' ')
        replica.backup()
        timer = time.time()

    time.sleep(5) # repeat this check every 5 seconds