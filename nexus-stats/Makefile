IMAGE = app
REGISTRY = 127.0.0.1:5000

all:

keypair:
	mkdir -p config/certs
	openssl genrsa \
		-out config/certs/auth.private.pem \
		2048
	openssl rsa \
		-pubout \
		-in config/certs/auth.private.pem  \
		-out config/certs/auth.public.pem

image:
	bash util/check-keypair.sh
	docker build -t $(REGISTRY)/$(IMAGE) .
	docker push $(REGISTRY)/$(IMAGE)