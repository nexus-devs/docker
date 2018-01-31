IMAGE = drone-staging
REGISTRY = 127.0.0.1:5000

all:

image:
	docker build -t $(REGISTRY)/$(IMAGE) .

publish:
	docker push $(REGISTRY)/$(IMAGE)