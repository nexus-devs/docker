import requests
import json
import pymongo

# Config
with open('/run/secrets/mongo-admin-pwd') as f: pwd = f.read().rstrip()
version = 0
config = { '_id': 'nexus', 'version': version, 'members': [] }


# Returns replica set config containing all hosts passed as param
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



# Apply new replica set config on primary. Will be triggered when nodes join
# or leave the swarm.
def rs_reconfig(target, config):
    mongo = pymongo.MongoClient(target + ':27017', replicaset='nexus',
                                username='admin', password=pwd, authSource='admin')
    mongo.admin.command('replSetReconfig', config)
    mongo.close()



# Intiate or reconfigure replica set
def config(hosts_current, active, added):
    config = get_rs_config(hosts_current)

    if len(active):
        print('> Found new hosts! Adding..')
        rs_reconfig(active[0], config)
        print('> Reconfigured replica set.')
    else:
        print('> First time setup, initiating on ' + added[0])
        rs_initiate(added[0], config)
        print('> Replica set initiated!')