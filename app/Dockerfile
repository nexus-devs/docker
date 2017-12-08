FROM alpine:latest

# Install node.js and npm (LTS)
RUN apk add --no-cache nodejs

# Get the nexus-stats repo
RUN apk add --no-cache git python build-base \
  && npm install node-gyp -g \
  && mkdir /app \
  && cd app \
  && git clone https://github.com/nexus-devs/nexus-stats \
  && cd nexus-stats \
  && npm install
COPY config/blitz.config.js /app/nexus-stats/config
