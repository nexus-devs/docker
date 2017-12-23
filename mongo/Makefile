IMAGE = mongo
REGISTRY = 127.0.0.1:5000

all:

pass:
	pwgen -s 64 1 > admin-pwd
	docker secret create mongo-admin-pwd admin-pwd
	rm admin-pwd

keyfile:
	openssl rand -base64 756 > keyfile
	docker secret create mongo-keyfile keyfile
	rm keyfile

image:
	bash util/check-keyfile.sh
	bash util/check-admin-pwd.sh
	docker build -t $(REGISTRY)/$(IMAGE) .
	docker push $(REGISTRY)/$(IMAGE)