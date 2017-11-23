FROM alpine:edge

# Install mongodb
RUN \
apk add --no-cache mongodb && \
rm /usr/bin/mongoperf
VOLUME /data/db
EXPOSE 27017 28017

# Copy mongo shell scripts for db setup
COPY ./mongo /root

# Entry point for starting mongo
COPY ./entry.sh /root
ENTRYPOINT [ "/root/entry.sh" ]
CMD [ "mongod" ]