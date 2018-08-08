### NexusHub MongoController

#### What does this do?
Automatically configures the mongo replica set of connected containers. From
the first initialization to subsequent configuration changes when containers
are joining or leaving.

#### How does it work?
Just loops, timers and minimal API servers on the mongo docker image. Most of
the functionality of individual endpoints is described there.

#### Backups
Backups are automatically taken every 12 hours on the **hidden member** of a
replica set, lest the primary be affected by the ongoing dump process.
They're stored in the `mongo_backup` named volume bound to `/data/backups`.
These backups will automatically be restored, should the replica set need to be
re-initialized. (assuming a full shutdown and thus data loss)