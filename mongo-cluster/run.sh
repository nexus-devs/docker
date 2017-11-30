#!/bin/sh
docker run --name rs0 --env-file ./config/env -d $@ mongo-cluster