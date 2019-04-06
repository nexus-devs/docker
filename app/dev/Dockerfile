FROM nexusstats/nexus-stats:staging

# Fuck it, it's a dev image anyway
USER root

# Store node modules so we can override the mounted volume with them later.
RUN mkdir -p /tmp/nexushub \
  && mv /app/nexushub/node_modules /tmp/nexushub \
  && rm -rf /app/nexushub/*

# Script to ensure databases are up before starting node
COPY prelaunch.js /tmp/nexushub/prelaunch.js

# Entry point for starting the app
COPY entrypoint.sh /
CMD [ "sh", "/entrypoint.sh" ]
