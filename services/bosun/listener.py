from flask import Flask
from flask import request
import json
import subprocess
import os
import hashlib
import hmac

# Config
with open('/run/secrets/nexus-dockerhub-token') as f: token = f.read().rstrip()
app = Flask(__name__)
branch = os.environ['DEPLOY_BRANCH']


# Parse JSON into python dictionairy
def parse_request(req):
    payload = req.get_data()
    payload = json.loads(payload)

    return payload


# Validate post signature to match secret
def validate_signature(key, body, signature):
    signature_parts = signature.split('=')
    if signature_parts[0] != "sha1":
        return False
    generated_sig = hmac.new(str.encode(key), msg=body, digestmod=hashlib.sha1)
    return hmac.compare_digest(generated_sig.hexdigest(), signature_parts[1])


# Webhook route. We'll just redeploy the stack
@app.route('/deploy', methods=['POST'])
def ping():
    payload = parse_request(request)
    signature = request.headers['x-hub-signature']

    if not validate_signature(token, request.get_data(), signature):
        return 'Invalid Signature', 403

    if payload['state'] == 'success' and [x for x in payload['branches'] if x['name'] == branch]:
        print('* Received trigger for new images. Updating...')
        subprocess.call('docker stack deploy -c /compose/app.yml nexus', shell=True)
        return 'ok'
    else:
        return 'wrong branch, but ok.'


app.run(host='0.0.0.0', port=5000)
