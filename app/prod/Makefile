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

# Base images, containing only the staging/prod repo.
prod:
	make deps
	docker build -t $(registry)/nexus-stats -f Dockerfile.prod .
	docker push $(registry)/nexus-stats

staging:
	make deps
	docker build -t $(registry)/nexus-stats:staging -f Dockerfile.staging .
	docker push $(registry)/nexus-stats

deps:
	bash util/check-keypair.sh
	bash util/check-credentials.sh main auth ui warframe
