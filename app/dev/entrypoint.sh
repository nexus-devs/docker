#!/bin/sh
# Copy provided config over bind mount
rm -rf /app/nexus-stats/config/*
cp -r /tmp/nexus-stats/config /app/nexus-stats/

# Rebuild node_modules in case some deps were installed on a different host OS
cd app/nexus-stats
npm install

# Run in background so errors wouldn't restart container
pm2 start index.js --name app
pm2 logs