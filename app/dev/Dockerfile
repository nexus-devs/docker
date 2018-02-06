FROM node

# Add node-gyp for building node_modules later on
RUN npm install node-gyp -g

# Copy blitz-js config to tmp folder so we can override bind mount data at
# runtime
RUN mkdir -p /app/nexus-stats /tmp/nexus-stats
COPY config /tmp/nexus-stats/config

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]