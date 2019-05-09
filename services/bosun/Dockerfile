FROM alpine:latest

# Install dependencies
RUN apk add --no-cache python3 docker git make pwgen \
  && pip3 install flask

# Add controller scripts
COPY listener.py /

ENTRYPOINT [ "python3", "-u", "/listener.py" ]
