VERSION = 0.0.0
IMAGE = redis

all:

image:
	docker build -t $(IMAGE) .

publish:
	docker push $(IMAGE):$(VERSION)