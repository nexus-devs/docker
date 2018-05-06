REGISTRY = 127.0.0.1:5000

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
	bash util/check-keypair.sh
	bash util/check-credentials.sh main auth ui warframe
	cd images; docker build -t $(REGISTRY)/nexus-stats -f prod.Dockerfile .
	docker push $(REGISTRY)/nexus-stats

staging:
	bash util/check-keypair.sh
	bash util/check-credentials.sh main auth ui warframe
	cd images; docker build -t $(REGISTRY)/nexus-stats-staging -f staging.Dockerfile --no-cache .
	docker push $(REGISTRY)/nexus-stats-staging
