VERSION = 0.0.0
IMAGE = mongo-rs

all:

image:
	docker build -t $(IMAGE) --no-cache .

publish:
	docker push $(IMAGE):$(VERSION)