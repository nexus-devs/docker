FROM alpine:edge

# Install mongodb
RUN apk add --update mongodb mongodb-tools \
  && apk add --no-cache python3 build-base \
  && pip3 install pymongo flask requests \
  && apk del build-base

# Create database directory
RUN mkdir -p /data/logs /data/db /data/config /data/backups
RUN chown -R mongodb /data

# Add listener for replica set initiation
COPY listener.py /
COPY mongorestore.sh /
COPY mongodump.sh /

# Switch to non-root user
USER mongodb

# Entrypoint
COPY entrypoint.sh /
CMD [ "sh", "/entrypoint.sh" ]
