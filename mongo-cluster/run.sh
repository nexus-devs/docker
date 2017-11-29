#!/bin/sh
docker run --env-file ./config/env -d $@ mongo-cluster
