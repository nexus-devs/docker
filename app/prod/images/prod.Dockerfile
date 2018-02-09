FROM node

# Add nexus user to which we'll switch in custom images
RUN adduser --disabled-login --gecos "" nexus

# Clone the nexus-stats repo and build node_modules
RUN mkdir -p /app/nexus-stats \
  && cd app \
  && git clone -b development https://github.com/nexus-devs/nexus-stats \
  && chown -R nexus nexus-stats \
  && cd nexus-stats \
  && npm install node-gyp -g \
  && npm install \
  && chown -R nexus /app/nexus-stats/node_modules/blitz-js-view