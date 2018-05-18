FROM nexusstats/nexus-stats:staging

# Fuck it, it's a dev image anyway
USER root

# Store node modules so we can override the mounted volume with them later.
RUN mkdir -p /tmp/nexus-stats \
  && mv /app/nexus-stats/node_modules /tmp/nexus-stats \
  && rm -rf /app/nexus-stats/*

# Script to ensure databases are up before starting node
COPY prelaunch.js /tmp/nexus-stats/prelaunch.js

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
