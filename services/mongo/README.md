### Nexus-Stats Mongodb Replica Sets
<br>
Setup for Mongodb replica set members. The base image is mostly a default mongod
instance with the following data structure:

- `/data/db` - Data storage
- `/data/config` - Config files
- `/data/backups` - Auto-generated backups

Beyond that, this image also opens a minimal webserver that will listen to
instructions from the mongoc image in order to behave accordingly inside its
replica set and take automatic backups. Here's a quick rundown for each endpoint:

<br>

#### /ping
> GET /ping

Simple ping to see when the container is up. Mongoc will perform a check for
new containers every 5 seconds and apply changes.

<br>

#### /initiate
> POST /initiate
```
{
  config: <replica_config>,
  target: <container>,
  secret: <db-secret>
}
```

This will initiate a replica set starting from the current container. Only one
container will receive this instruction.

The `config` key describes the [replica set configuration object](https://docs.mongodb.com/manual/reference/replica-configuration/).

`target` is the container which will receive this instruction. If mongo selected
our replica primary to be this container, we'll add the `admin` user locally with
the password from the `mongo-admin-pwd` docker-secret. If mongo elected another
container, we'll trigger the `/admin` endpoint there.

The `secret` key in the POST object needs to match this password in order to run
the initialization.

<br>

#### /admin
> GET /admin

Creates the admin user (presumably on the primary of the replica set). Mongodb
has an issue where it can't initialize a replica set when not all members have
completely clear databases. However, we need our replica set to be protected
immediately without another restart, so we'll simply check who's the primary
and tell it to add admin credentials before we initialize the replica set.

<br>

#### /backup
> GET /backup

Takes a database backup if the container is a hidden member (to prevent any
performance impact on the primary). This will perform the `mongodump.sh`
script which stores data to the `mongo_backup` named volume on `/data/backups`.
`mongorestore.sh` is called automatically when an empty replica set is
initialized. It makes sure our data persists throughout restarts.

<br>

