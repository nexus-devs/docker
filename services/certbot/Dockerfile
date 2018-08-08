FROM alpine:latest

# Install dependencies
RUN apk add --no-cache certbot python3 \
  && pip3 install certbot-dns-cloudflare

COPY cli.ini /
COPY entrypoint.sh /

CMD [ "sh", "/entrypoint.sh" ]
