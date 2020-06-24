# We use Ubuntu here because Alpine dropped support for mongodb
FROM ubuntu:bionic

# Add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends gnupg build-essential python3 python3-pip wget \
  && pip3 install pymongo flask requests

# Install mongodb (DEBIAN_FRONTEND because tzdata package is interactive)
RUN export DEBIAN_FRONTEND=noninteractive \
  && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - \
  && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list \
  && apt-get update \
  && apt-get install -y mongodb-org

# Create database directory
RUN mkdir -p /data/logs /data/db /data/config /data/backups
RUN chown -R mongodb:mongodb /data/logs /data/db /data/config /data/backups

# Add listener for replica set initiation
COPY listener.py /
COPY mongorestore.sh /
COPY mongodump.sh /

# Switch to non-root user
USER mongodb

# Entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
