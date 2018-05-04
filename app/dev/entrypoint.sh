#!/bin/sh
# Install modules for current OS
cd app/nexus-stats
git checkout development

if [ -d "node_modules" ] && [ ! -f "node_modules/.docker" ]; then
  rm -rf node_modules
fi
if [ ! -d "node_modules" ] || [ ! -f "node_modules/.docker" ]; then
  npm install
  npm rebuild node-sass # Don't ask me why it doesn't do this by default
  echo '' >> node_modules/.docker # Ensure that we won't rebuild on the next run
fi

# Wait for databases
node /tmp/nexus-stats/prelaunch.js

# Launch
npm start
