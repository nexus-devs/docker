#!/bin/sh
# Read hosts file content to generate cluster member config from, then insert in
# cluster script
hosts="./config/hosts"
id=0

while read line; do
  host="${line##* }" # last word in line
  member="{ _id: $id, host: $host },"
  sed -i "/\/\/ members generated from \/config\/hosts/a \\\t\t${member}" mongo/cluster.js
  let "id++"
done < $hosts