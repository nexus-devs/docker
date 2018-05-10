from flask import Flask
from flask import request
import subprocess

# Config
with open('/run/secrets/nexus-dockerhub-token') as f: token = f.read().rstrip()
app = Flask(__name__)


# Webhook route. We'll just redeploy the stack
@app.route(token, methods=['POST'])
def ping():
    print('* Received trigger for new images. Updating...')
    subprocess.Popen(['docker stack deploy -c /docker-compose.yml nexus'])


app.run(host='0.0.0.0', port=5000)
