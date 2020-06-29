FROM alpine:3.9.6

# Install dependencies
RUN apk add --no-cache python3 docker mongodb \
	&& pip3 install docker pymongo requests

# Add controller scripts
COPY controller.py /
COPY replica.py /

ENTRYPOINT [ "python3", "-u", "/controller.py" ]