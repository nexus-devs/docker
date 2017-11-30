### Nexus-Stats Mongodb Replica Sets
Setup for Mongodb replica sets, including internal authentication and DNS management.

<br>

#### Run locally
1. Set your database passwords in [/config/env](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/env)
2. `make image && bash run-local.sh`

<br>

#### Distributed Replica Set
1. Set your replica set IPs in [/config/hosts](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/hosts). (We'll use that for DNS records in our mongo cluster)
2. Set your database passwords in [/config/env](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/env)
3. Ensure your secondary mongod instances are running first with `bash run.sh '--env IS_SECONDARY=true'`
4. Only then, run your intended primary instance with `bash run.sh`

Keep in mind that the primary may switch to any other instance at runtime. But
we have to initiate the replica set on only one instance first, which then also
becomes the first primary.