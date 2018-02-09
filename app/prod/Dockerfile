FROM 127.0.0.1:5000/nexus-stats

# Override config
COPY config/blitz.config.js /app/nexus-stats/config/

# Drop root perms
USER nexus

# Add script which adds node credentials to mongo
COPY prelaunch.js /app/nexus-stats/prelaunch.js

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
