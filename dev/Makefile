IMAGE = app
REGISTRY = 127.0.0.1:5000
PREFIX = nexus

all:

keypair:
	mkdir -p config/certs
	openssl genrsa \
		-out private.pem \
		2048
	openssl rsa \
		-pubout \
		-in private.pem  \
		-out public.pem
	docker secret create nexus-private-key private.pem
	docker secret create nexus-public-key public.pem
	rm private.pem
	rm public.pem

image:
	bash util/check-keypair.sh
	docker build -t $(REGISTRY)/nexus-stats-dev .
	docker push $(REGISTRY)/nexus-stats-dev