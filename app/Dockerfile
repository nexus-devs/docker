FROM alpine:latest

# Install node.js and npm (LTS)
RUN apk add --update nodejs \
  && npm install pm2 -g

# Install build requirements
RUN apk add --update git python build-base libpng-dev \
  && npm install node-gyp -g

# Clone the nexus-stats repo
RUN mkdir /app \
  && cd app \
  && git clone https://github.com/nexus-devs/nexus-stats

# Build node modules
RUN cd /app/nexus-stats \
  && npm install

# Copy blitz-js config
COPY config /app/nexus-stats/config/

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]