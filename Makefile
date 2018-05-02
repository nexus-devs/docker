all:

dev:
	cd services/mongo; make image
	cd services/mongoc; make image
	cd services/redis; make image
	cd app/dev; make image

prod:
	cd services/mongo; make image
	cd services/mongoc; make image
	cd services/redis; make image
	cd services/nginx; make image
	cd app/prod; make prod; make image
