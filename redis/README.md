### Nexus-Stats Redis Setup
Setup for very simple non-clustered redis server based on alpine. Will listen on
:6379 by default.

#### Run locally
1. Set your redis config in [/config/redis-override.conf](https://github.com/nexus-devs/docker/blob/master/redis/config/redis-override.conf)
2. `make image && bash run.sh`