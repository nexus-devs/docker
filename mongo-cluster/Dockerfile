FROM alpine:edge

# Install mongodb
RUN \
apk add --no-cache mongodb && \
rm /usr/bin/mongoperf
VOLUME /data/db
EXPOSE 27017 27017

# Add hosts
COPY ./config/hosts /data/config/hosts

# Entry point for starting mongo
COPY ./entry.sh /root
ENTRYPOINT [ "/root/entry.sh" ]