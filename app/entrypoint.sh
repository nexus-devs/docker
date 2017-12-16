#!/bin/sh
cd /app/nexus-stats
pm2 start index.js --name app && pm2 logs