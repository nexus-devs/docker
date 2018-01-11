FROM node

# Add nexus user to which we'll switch later
RUN adduser --disabled-login --gecos "" nexus

# Clone the nexus-stats repo and build node_modules
RUN mkdir -p /app/nexus-stats \
  && cd app \
  && git clone https://github.com/nexus-devs/nexus-stats \
  && chown -R nexus nexus-stats \
  && cd nexus-stats \
  && npm install node-gyp -g \
  && npm i \
  && chown -R nexus /app/nexus-stats/node_modules/blitz-js-view

# Override config
COPY config/blitz.config.js /app/nexus-stats/config/

# Drop root perms
USER nexus

# Add script which adds node credentials to mongo
COPY prelaunch.js /app/nexus-stats/prelaunch.js

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]