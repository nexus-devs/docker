#!/bin/sh
# cd to repo so process.cwd() works correctly
cd app/nexus-stats

# Run script for adding node credentials to mongo
node prelaunch.js

# Run cubic node
node .