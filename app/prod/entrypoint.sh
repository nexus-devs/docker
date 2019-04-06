#!/bin/sh
# cd to repo so process.cwd() works correctly
cd app/nexushub

# Run script for adding node credentials to mongo
node prelaunch.js

# Run cubic node
npm start
