# Simple web server to listen for replica set initiation trigger.
#
# We'll have to make use of mongodb's localhost exception to create a new
# admin user on our replica set, as well as initiate the replica set in the
# first place.
#
# This process gets killed as soon as a replica set is initiated.

from flask import Flask
from flask import request
import sys
import os
import shutil
import time
import requests
import json
import pymongo

# Config
with open('/run/secrets/mongo-admin-pwd') as f: pwd = f.read().rstrip()
app = Flask(__name__)


# Ping to check when mongodb is up
@app.route('/ping', methods=['GET'])
def ping():
    up = False
    mongo = pymongo.MongoClient()

    while not up:
        if mongo.admin.command('ping')['ok']:
            up = True
            mongo.close()
            return "pong"
        else:
            time.sleep(1)



# Initiate replica set with provided config
@app.route('/initiate', methods=['POST'])
def initiate():
    config = request.json['config']
    target = request.json['target']
    secret = request.json['secret']

    # Connect to mongo and initiate, then add admin user
    if secret == pwd:

        # Login as admin if credentials already exist
        try:
            mongo = pymongo.MongoClient(username='admin', password=pwd, authSource='admin')
            existed = True
        except:
            mongo = pymongo.MongoClient()

        # Init
        mongo.admin.command('replSetInitiate', config)

        # Get primary
        time.sleep(20)
        rs = mongo.admin.command('replSetGetStatus')
        mongo.close()
        primary = None
        for member in rs['members']:
            if member['stateStr'] == 'PRIMARY':
                primary = member['name'].split(':')[0]

        # Create admin user on primary (either here or remote). Only do this if
        # there isn't an existing admin user.
        if not existed:
            # > Here
            if primary == target:
                admin()
            # > Remote
            else:
                try:
                    requests.get('http://' + primary + ':27027/admin')
                except:
                    pass

        return 'ok'

    # Incorrect secret
    else:
        return '403'



# Take database backup. This will only get called if we're a hidden member.
@app.route('/backup', methods=['GET'])
def backup():
    os.system('/bin/sh /mongodump.sh')
    return 'ok'



# Create admin user. This only gets triggered on the primary container in order
# to make use of the localhost exception for creating users.
@app.route('/admin', methods=['GET'])
def admin():
    mongo = pymongo.MongoClient()
    mongo.admin.add_user('admin', pwd, roles=[{ 'role': 'root', 'db': 'admin' }])
    mongo.close()
    return 'ok'

app.run(host='0.0.0.0', port=27027)
