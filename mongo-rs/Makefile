VERSION = 0.0.0
IMAGE = mongo-rs

all:

keyfile:
	openssl rand -base64 756 > config/keyfile

image:
	bash util/check-keyfile.sh
	docker build -t $(IMAGE) --no-cache .

publish:
	docker push $(IMAGE):$(VERSION)