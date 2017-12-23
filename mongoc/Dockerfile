FROM alpine:latest

# Install dependencies
RUN apk add --no-cache python3 docker mongodb \
	&& pip3 install docker pymongo requests

# Step down from root
RUN adduser -D mongoc
USER mongoc

# Add controller script
COPY controller.py /
ENTRYPOINT [ "python3", "-u", "/controller.py" ]