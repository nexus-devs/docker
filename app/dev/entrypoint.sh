#!/bin/sh
# Copy provided config over bind mount
rm -rf /app/nexus-stats/config/*
cp -r /tmp/nexus-stats/config /app/nexus-stats/

cd app/nexus-stats
if [! -d "node_modules" ]; then
  npm install
fi

npm start