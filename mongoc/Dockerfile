FROM alpine:latest

# Install dependencies
RUN apk add --no-cache python3 docker mongodb \
	&& pip3 install docker pymongo

ENTRYPOINT [ "top" ]