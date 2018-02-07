#!/bin/sh
# Copy provided config over bind mount
rm -rf /app/nexus-stats/config/*
cp -r /tmp/nexus-stats/config /app/nexus-stats/

# Install modules for current OS (do NOT override!)
cd app/nexus-stats
if [ ! -d "node_modules" ]; then
  npm install
  npm rebuild node-sass # because modern web-development
fi

# Add our custom config files for this image to gitignore
echo "*" >> config/.gitignore

npm start