VERSION = 0.0.0
IMAGE = nginx

all:

image:
	docker build -t $(IMAGE) .

publish:
	docker push $(IMAGE):$(VERSION)