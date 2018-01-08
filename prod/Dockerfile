FROM node

# Add nexus user to which we'll switch later
RUN adduser --disabled-login --gecos "" nexus

# Add node-gyp for building node_modules later on
RUN npm install node-gyp -g

# Clone the nexus-stats repo
RUN mkdir /app \
  && cd app \
  && git clone https://github.com/nexus-devs/nexus-stats

# Build node modules
RUN cd /app/nexus-stats \
  && npm install

# Override config
COPY config/blitz.config.js /app/nexus-stats/config

# Drop root perms
USER nexus

# Add script which adds node credentials to mongo
COPY prelaunch.js /app/nexus-stats/prelaunch.js

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]