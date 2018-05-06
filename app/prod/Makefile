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
	cd images; docker build -t $(registry)/nexus-stats -f prod.Dockerfile .
	docker push $(registry)/nexus-stats

staging:
	make deps
	cd images; docker build -t $(registry)/nexus-stats-staging -f staging.Dockerfile --no-cache .
	docker push $(registry)/nexus-stats-staging

deps:
	bash util/check-keypair.sh
	bash util/check-credentials.sh main auth ui warframe
