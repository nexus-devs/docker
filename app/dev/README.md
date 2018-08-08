## NexusHub Development Image

### Live editing
In order to write code as usual, this image expects a bind mount from the
nexus repo on `/app/nexus-stats` inside the container. The deploy script will
automatically take the provided path when the `--dev` flag is present and
adjust docker-compose files accordingly.

### Configuration
The configuration of individual nodes is done directly through the NexusHub
repo's [config files](https://github.com/nexus-devs/nexus-stats/tree/development/config/cubic).
Generally, there are no differences besides different database resolvers and
RSA keys.