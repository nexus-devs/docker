#!/bin/sh
# Cloudflare config
mv /cli.ini /etc/letsencrypt/cli.ini
token=$(cat /run/secrets/nexus-cloudflare-token)
echo "dns_cloudflare_api_key = $token" > /etc/letsencrypt/dnscloudflare.ini
echo "dns_cloudflare_email = apps@nexus-stats.com" >> /etc/letsencrypt/dnscloudflare.ini

# Initial setup
certbot certonly \
  -d *.nexushub.io -d *.nexushub.co -d nexushub.io -d nexushub.co \
  -m devs@nexus-stats.com \
  --dns-cloudflare \
  --agree-tos \
  --non-interactive

# Check for renewal every hour
while : ; do
  certbot renew
  sleep "$((60 * 60))"
done
