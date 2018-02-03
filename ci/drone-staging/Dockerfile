FROM alpine:latest

# Install dependencies
RUN apk add --no-cache docker

# Clone docker repo for test images
git clone https://github.com/nexus-devs/docker

COPY stage.sh /
COPY deploy.sh /
COPY undeploy.sh /

# Entry point for starting the app
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]