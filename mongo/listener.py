# Simple web server to listen for replica set initiation trigger.
#
# We'll have to make use of mongodb's localhost exception to create a new
# admin user on our replica set, as well as initiate the replica set in the
# first place.
#
# This process gets killed as soon as a replica set is initiated.

from flask import Flask
from flask import request
import pymongo
import json
import time
import requests

# Config
with open('/run/secrets/mongo-admin-pwd') as f: pwd = f.read().rstrip()
app = Flask(__name__)
i_can_die_now = False

def add_admin():
    # Create admin user
    mongo = pymongo.MongoClient(replicaset='nexus-rs')
    time.sleep(10) # wait for connection
    mongo.admin.add_user('admin', pwd, roles=[{ 'role': 'root', 'db': 'admin' }])

# Listen to routes
@app.route('/kill', methods=['GET'])
def kill():
    i_can_die_now = True
    return "ok"

@app.route('/initiate', methods=['POST'])
def initiate():
    config = request.json['config']
    target = request.json['target']
    secret = request.json['secret']

    # Connect to mongo and initiate, then add admin user
    if secret == pwd:
        mongo = pymongo.MongoClient()
        mongo.admin.command('replSetInitiate', config)
        mongo.close()
        add_admin()

        i_can_die_now = True
        return "ok"
    else:
        return '403'

@app.route('/admin', methods=['GET'])
def admin():
    add_admin()
    return "ok"

app.run(host='0.0.0.0', port=27027)

# Kill check
while True:
    if i_can_die_now:
        quit()
    time.sleep(10)