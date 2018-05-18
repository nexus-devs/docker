#!/bin/sh

# Wait for databases
cd /tmp/nexus-stats
node prelaunch.js

# node_modules present but no .docker file indicating previous copy? Or no
# node_modules at all? Then use pre-built node_modules.
cd /app/nexus-stats

if ([ -d "node_modules" ] && [ ! -f "node_modules/.docker" ]) || [ ! -d "node_modules" ]; then
  echo '\n* Installing pre-compiled node_modules, this may take a while...'
  mv /tmp/nexus-stats/node_modules /app/nexus-stats
  echo ' ' >> node_modules/.docker
fi

# Launch
npm start
