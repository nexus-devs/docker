FROM alpine:latest

# Add nexus user to which we'll switch later
RUN adduser --disabled-login --gecos "" nexus

# Install dependencies
RUN apk add --no-cache python3 docker \
	&& pip3 install docker

# Drop root perms
USER nexus

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]