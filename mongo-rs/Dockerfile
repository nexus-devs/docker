FROM alpine:edge

# Install mongodb
RUN \
apk add --no-cache mongodb && \
rm /usr/bin/mongoperf
VOLUME /data/db

# Add hosts
COPY ./config/members /data/config/members

# Entry point for starting mongo
COPY ./entry.sh /root
ENTRYPOINT [ "/root/entry.sh" ]