FROM alpine:latest

# Install dependencies
RUN apk add --no-cache python3 docker mongodb \
	&& pip3 install docker pymongo requests \
	&& mkdir -p /data/backups

# Add controller script
COPY controller.py /
ENTRYPOINT [ "python3", "-u", "/controller.py" ]