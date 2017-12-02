FROM alpine:edge

# Install mongodb
RUN apk add --no-cache mongodb && rm /usr/bin/mongoperf

# Add config
COPY config/members /data/config/members
COPY config/keyfile /data/config/keyfile
RUN cat /data/config/members >> /etc/hosts

# Create database volume (dir first, then we get perms, then we attach volume)
RUN mkdir /data/logs /data/db
RUN chown -R mongodb /data
VOLUME /data/db

# Entry point for starting mongo
COPY entry.sh /

# Switch to non-root user
USER mongodb
RUN chmod 400 /data/config/keyfile

ENTRYPOINT [ "/entry.sh" ]