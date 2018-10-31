import requests
import json
import pymongo

# Config
with open('/run/secrets/mongo-admin-pwd') as f: pwd = f.read().rstrip()
version = 0
config = { '_id': 'nexus', 'version': version, 'members': [] }
hidden = ''


# Returns replica set config containing all hosts passed as param
def get_rs_config(hosts):
    global version
    global hidden
    members = config['members']

    # Remove old hosts
    for mongo in members:
        host = mongo['host'].split(':')[0]

        # Already exists => remove from new hosts
        if host in hosts:
            hosts.remove(host)
        # Got dropped => remove from config
        else:
            config['members'] = [m for m in config['members'] if m['_id'] != mongo['_id']]

    # Set new version (can't do rs.reconfig() without this)
    version += 1
    config['version'] = version

    # Append new hosts to config
    x = len(members) - 1
    last_id = members[x]['_id'] if x >= 0 else 0

    for i in range(len(hosts)):
        member = { '_id': last_id + i + 1, 'host': hosts[i] + ':27017' }

        # Make last member hidden so we can take backups without
        # interrupting the service.
        if i >= len(hosts) - 1 and len(hosts) > 1:
            member['priority'] = 0
            hidden = hosts[i]
            print('> Choosing hidden member: ' + hosts[i])

        config['members'].append(member)
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
def reconfig(hosts_current, active, added):
    config = get_rs_config(list(hosts_current))

    if len(active):
        print('> Found new hosts! Adding..')
        rs_reconfig(active[0], config)
        print('> Reconfigured replica set.')
    else:
        print('> First time setup, initiating on ' + added[0])
        rs_initiate(added[0], config)
        print('> Replica set initiated!')



# Trigger backup on hidden node. Data will be stored in 'mongo-backup' volume.
def backup():
    if hidden:
        requests.get('http://' + hidden + ':27027/backup')
