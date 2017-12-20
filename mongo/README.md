### Nexus-Stats Mongodb Replica Sets
Setup for Mongodb replica sets, including internal authentication and DNS management.

<br>

#### Run locally
1. Set your database passwords in [/config/env](https://github.com/nexus-devs/docker/blob/master/mongo-rs/config/env)
2. `make image && bash run.sh`

<br>

#### Distributed Replica Set
1. `make keyfile`. This file needs to be present on all machines in the replica
 set. We'll use it for internal authentication.
2. Set your replica member IPs in [/config/members](https://github.com/nexus-devs/docker/blob/master/mongo-rs/config/members).
 We assume the first member to be the replica set primary.
3. Set your database passwords in [/config/env](https://github.com/nexus-devs/docker/blob/master/mongo-rs/config/env)
4. `make image && bash run.sh`

**Note:** Keep in mind that the primary may switch to any other instance at
runtime. But we have to initiate the replica set on only one instance first,
which then also becomes the first primary.

#### Volumes
Volumes for data persistence are automatically stored by the container name you
specify through the member config. Run `docker volume ls` to get a list of them.