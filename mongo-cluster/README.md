### Nexus-Stats Mongodb Replica Sets
Setup for Mongodb replica sets, including internal authentication and DNS management.

#### Build Locally
1. Set your replica set IPs in [/config/hosts](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/hosts). (We'll use that for DNS records in our mongo cluster)
2. Set your database passwords in [/config/env](https://github.com/nexus-devs/docker/blob/master/mongo-cluster/config/env)
3. `make image && bash run.sh`