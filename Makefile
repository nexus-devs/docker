all:

dev:
	cd app/mongo; make image
	cd app/mongoc; make image
	cd app/redis; make image
	cd app/dev; make image

prod:
	cd app/mongo; make image
	cd app/mongoc; make image
	cd app/redis; make image
	cd app/nginx; make image
	cd app/prod; make prod; make image

cicd:
	cd ci/drone-nginx; make image
	cd ci/drone-staging; make image