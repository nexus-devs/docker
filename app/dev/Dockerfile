FROM node

# Add nexus user to which we'll switch later
RUN adduser --disabled-login --gecos "" nexus

# Add node-gyp for building node_modules later on
RUN npm install node-gyp pm2 -g

# Copy blitz-js config to tmp folder so we can override bind mount data at
# runtime
RUN mkdir -p /app/nexus-stats /tmp/nexus-stats \
  && chown -R nexus /app/nexus-stats /tmp/nexus-stats
COPY config /tmp/nexus-stats/config

# Drop root perms
USER nexus

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]