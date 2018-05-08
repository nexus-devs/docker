all:

dev:
	cd services/mongo; make image registry=$(registry)
	cd services/mongoc; make image registry=$(registry)
	cd services/redis; make image registry=$(registry)
	cd app/dev; make image registry=$(registry)

dev-deps:
	cd services/mongo; make deps
	cd app/dev; make deps

prod:
	cd services/mongo; make image registry=$(registry)
	cd services/mongoc; make image registry=$(registry)
	cd services/redis; make image registry=$(registry)
	cd services/nginx; make image registry=$(registry)
	cd app/prod; make image registry=$(registry)

prod-deps:
	cd services/mongo; make deps
	cd app/prod; make deps
