FROM node:alpine

# Build dependencies
RUN apk --update add git openssh make gcc g++ python \
  && npm install node-gyp -g

# Script to ensure databases are up before starting node
RUN mkdir -p /app/nexus-stats /tmp/nexus-stats
COPY prelaunch.js /tmp/nexus-stats/prelaunch.js

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
