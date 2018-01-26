REGISTRY = 127.0.0.1:5000

all:

image:
	docker build -t $(REGISTRY)/drone-nginx -f drone-nginx.dockerfile .
	docker push $(REGISTRY)/drone-nginx