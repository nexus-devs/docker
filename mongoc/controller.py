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
import backup

# Config
docker = docker.APIClient(base_url='unix://var/run/docker.sock')
service = os.environ['SERVICE_NAME'] or 'mongo'
hosts = []


# Ping listener to figure out when container is ready
def ping(hosts):
    for host in hosts:
        resolved = False

        while not resolved:
            try:
                requests.get('http://' + host + ':27027/ping')
                resolved = True
            except:
                time.sleep(1)



# Get container names from docker tasks which we'll resolve to
def get_host_names():
    containers = docker.tasks(filters = { 'service': service })
    host_names = []

    for container in containers:
        host_names.append(service + '.' + str(container['Slot']) + '.' + container['ID'])
    return host_names



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
        replica.config(hosts_current, active, added)
    else:
        print('> Nothing new.')

    print(' ')
    hosts = hosts_current
    time.sleep(5) # repeat this check every 5 seconds