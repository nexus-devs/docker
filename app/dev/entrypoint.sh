#!/bin/sh
# Install modules for current OS
cd app/nexus-stats

if [ -d "node_modules" ] && [ ! -f "node_modules/.docker" ]; then
  npm rebuild
  echo ' ' >> node_modules/.docker
fi
if [ ! -d "node_modules" ]; then
  npm install
  npm rebuild node-sass # Don't ask me why it doesn't do this by default
  echo ' ' >> node_modules/.docker
fi

# Wait for databases
node /tmp/nexus-stats/prelaunch.js

# Launch
npm start
