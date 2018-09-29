all:

dev:
	cd services/mongo; make image registry=$(registry)
	cd services/mongoc; make image registry=$(registry)
	cd services/redis; make image registry=$(registry)
	cd app/dev; make image registry=$(registry)

dev-deps:
	cd services/mongo; make -B deps
	cd app/dev; make -B deps

staging:
	cd services/mongo; make image registry=$(registry)
	cd services/mongoc; make image registry=$(registry)
	cd services/redis; make image registry=$(registry)
	cd services/nginx; make image registry=$(registry)
	cd services/certbot; make image registry=$(registry)
	cd services/bosun; make image registry=$(registry)
	cd app/prod; make staging registry=$(registry)

prod:
	cd services/mongo; make image registry=$(registry)
	cd services/mongoc; make image registry=$(registry)
	cd services/redis; make image registry=$(registry)
	cd services/nginx; make image registry=$(registry)
	cd services/certbot; make image registry=$(registry)
	cd services/bosun; make image registry=$(registry)
	cd app/prod; make prod registry=$(registry)

prod-deps:
	cd services/mongo; make -B deps
	cd app/prod; make -B deps
