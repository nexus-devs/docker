FROM alpine:latest

# Install build requirements
RUN apk add --update --virtual .build-deps build-base linux-headers openssl

# Get redis source code
RUN wget https://github.com/antirez/redis/archive/4.0.5.tar.gz \
    && tar xzf 4.0.5.tar.gz

# Build from source
RUN cd redis-4.0.5 \
    && make \
    && make install \
    && mkdir /etc/redis \
    && cp redis.conf /etc/redis/

# Cleanup
RUN apk del .build-deps build-base \
    && rm -rf /redis-4.0.5

# Add config
RUN adduser -D redis \
    && echo -e "include /etc/redis/redis-override.conf\n" >> /etc/redis/redis.conf
COPY config/redis-override.conf /etc/redis/redis-override.conf

# Drop root perms and run server
USER redis
ENTRYPOINT [ "redis-server", "/etc/redis/redis.conf" ]