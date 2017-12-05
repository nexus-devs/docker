FROM alpine:latest

# Install Redis
RUN apk add --no-cache --virtual .build-deps build-base linux-headers openssl \
    && wget https://github.com/antirez/redis/archive/4.0.5.tar.gz \
    && tar xzf 4.0.5.tar.gz \
    && cd redis-4.0.5 \
    && make \
    && make install \
    && mkdir /etc/redis \
    && cp redis.conf /etc/redis/ \
    && adduser -D redis \
    && apk del .build-deps \
    && rm -rf /redis-4.0.5 \
    && echo -e "include /etc/redis/redis-override.conf\n " >> /etc/redis/redis.conf
COPY config/redis-override.conf /etc/redis/redis-override.conf

# Drop root perms and run server
USER redis
CMD redis-server /etc/redis/redis.conf