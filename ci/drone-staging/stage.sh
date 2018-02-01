#!/bin/sh
cd $1
date=`date '+%Y-%m-%d %H:%M:%S'`
user=${nexus-ci-user}
pass=${nexus-ci-pass}

# Commit to specified remote branch (usually staging or production)
git add -A
git commit -m "Automatic drone-ci build ($date)"
git push https://$user:$pass@github.com/nexus-devs/nexus-stats $2:$3