### NexusHub MongoController

#### What does this do?
Automatically configures the mongo replica set of connected containers. From
the first initialization to subsequent configuration changes when containers
are joining or leaving. So, it's really just replica set configuration across
docker swarm.

#### How does it work?
Just loops, timers and minimal API servers on the mongo docker image. Most of
the functionality of individual endpoints is described there.

#### Backups
Backups are automatically taken every 12 hours on the **hidden member** of a
replica set, lest the primary be affected by the ongoing dump process.
They're stored in the `mongo_backup` named volume bound to `/data/backups`.
These backups will automatically be restored, should the replica set need to be
re-initialized. (assuming a full shutdown and thus data loss)

#### Other things to note
This image requires access to the docker sock in order to see what's on the
swarm. As a result, double checking the security of this image is absolutely
necessary, as an exploit could lead to taking over the entire swarm.
