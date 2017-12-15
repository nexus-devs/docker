VERSION = 0.0.0
IMAGE = nexus-stats

all:

image:
	docker build -t $(IMAGE) .

publish:
	docker push $(IMAGE):$(VERSION)