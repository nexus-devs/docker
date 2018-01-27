REGISTRY = 127.0.0.1:5000
IMAGE = drone-nginx

all:

image:
	docker build -t $(REGISTRY)/$(IMAGE) .
	docker push $(REGISTRY)/$(IMAGE)