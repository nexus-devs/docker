FROM 127.0.0.1:5000/nexus-stats-dev

# Add nexus user to which we'll switch later
RUN adduser --disabled-login --gecos "" nexus

# Drop root perms
USER nexus