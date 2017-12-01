### Nexus-Stats Mongodb Replica Sets
Setup for Mongodb replica sets, including internal authentication and DNS management.

<br>

#### Run locally
1. Set your database passwords in [/config/env](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/env)
2. `make image && bash run.sh`

<br>

#### Distributed Replica Set
1. Set your replica member IPs in [/config/members](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/members). (We assume the first member to be the replica primary. DNS records are optional.)
2. Set your database passwords in [/config/env](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/env)
3. Ensure your secondary mongod instances are running first with `bash run.sh`
4. Only then, run `bash run.sh` on your primary's machine

Keep in mind that the primary may switch to any other instance at runtime. But
we have to initiate the replica set on only one instance first, which then also
becomes the first primary.