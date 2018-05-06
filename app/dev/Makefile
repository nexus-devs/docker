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
	make deps
	docker build -t $(registry)/nexus-stats-dev .
	docker push $(registry)/nexus-stats-dev

deps:
	bash util/check-keypair.sh
