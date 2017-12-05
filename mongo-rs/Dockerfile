FROM alpine:latest

# Install mongodb
RUN apk add --no-cache mongodb && rm /usr/bin/mongoperf

# Add config
COPY config/members /data/config/members
COPY config/keyfile /data/config/keyfile

# Create database volume directory so we can get perms for mongodb user
# Must be done before mounting volume, otherwise it's locked to root
RUN mkdir /data/logs /data/db
RUN chown -R mongodb /data

# Entry point for starting mongo
COPY entry.sh /

# Switch to non-root user
USER mongodb
RUN chmod 400 /data/config/keyfile

ENTRYPOINT [ "/entry.sh" ]