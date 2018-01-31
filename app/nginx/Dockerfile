FROM alpine:latest

ENV NGINX_VERSION=1.12.2

# Get build requirements
RUN apk add --update build-base ca-certificates linux-headers openssl openssl-dev pcre pcre-dev wget zlib zlib-dev

# Get nginx source files
RUN cd /tmp \
  && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar xzf nginx-${NGINX_VERSION}.tar.gz

# Build nginx from source files
RUN cd /tmp/nginx-${NGINX_VERSION} \
  && ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-threads \
  && make \
  && make install \
  && mkdir -p /etc/nginx/conf/certs /etc/nginx/logs \
  && rm -rf /tmp/* \
  && apk del build-base linux-headers openssl-dev pcre-dev wget zlib-dev \
  && rm -rf /var/cache/apk/*

COPY config /etc/nginx/conf/

# Add nginx user (wouldn't wanna run as root)
RUN adduser -D nginx

ENTRYPOINT ["nginx", "-g", "daemon off;"]