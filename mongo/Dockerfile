FROM alpine:latest

# Install mongodb
RUN apk add --update mongodb && rm /usr/bin/mongoperf \
  && apk add --no-cache python3 build-base \
  && pip3 install pymongo flask requests \
  && apk del build-base

# Create database volume directory so we can get perms for mongodb user
# Must be done before mounting volume, otherwise it's locked to root
RUN mkdir -p /data/logs /data/db /data/config
RUN chown -R mongodb /data
VOLUME [ "/data/db" ]

# Add listener for replica set initiation
COPY listener.py /

# Switch to non-root user
USER mongodb

# Entrypoint
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]