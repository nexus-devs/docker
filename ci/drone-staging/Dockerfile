FROM alpine:latest

# Install dependencies
RUN apk add --no-cache docker

# Clone docker repo for test images
git clone https://github.com/nexus-devs/docker

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]