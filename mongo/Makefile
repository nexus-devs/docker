IMAGE = mongo
REGISTRY = 127.0.0.1:5000

all:

keyfile:
	openssl rand -base64 756 > keyfile
	docker secret create mongo-keyfile keyfile
	rm keyfile

image:
	bash util/check-keyfile.sh
	docker build -t $(REGISTRY)/$(IMAGE) .
	docker push $(REGISTRY)/$(IMAGE)