#!/bin/sh
cd $1
date=`date '+%Y-%m-%d %H:%M:%S'`
user=${nexus-ci-user}
pass=${nexus-ci-pass}

#

# Commit to specified remote branch
git add -A
git commit -m "Automatic drone-ci build ($date)"
git push origin $2:$3