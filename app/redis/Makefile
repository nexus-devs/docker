IMAGE = redis
REGISTRY = 127.0.0.1:5000

all:

image:
	docker build -t $(REGISTRY)/$(IMAGE) .
	docker push $(REGISTRY)/$(IMAGE)