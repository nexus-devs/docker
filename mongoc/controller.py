import docker
import pymongo

client = docker.APIClient(base_url='unix://var/run/docker.sock')
service = 'nexus-mongo'


def get_host_names():
    containers = client.tasks(filters = { 'service': service })
    host_names = []

    for container in containers:
        host_names.append(service + '.' + str(container['Slot']) + '.' + container['ID'])
    return host_names


print(get_host_names())