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

prod:
	docker build -t $(REGISTRY)/nexus-stats -f images/prod.Dockerfile .
	docker push $(REGISTRY)/nexus-stats

staging:
	docker build -t $(REGISTRY)/nexus-stats -f images/staging.Dockerfile --no-cache .
	docker push $(REGISTRY)/nexus-stats

image:
	bash util/check-keypair.sh
	bash build.sh api-warframe api-auth api-view \
		core-warframe core-auth core-view
