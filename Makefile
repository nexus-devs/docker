all:

images:
	cd app/mongo; make image
	cd app/mongoc; make image
	cd app/redis; make image
	cd app/nginx; make image
	cd app/dev; make image
	cd app/prod; make image
	cd ci/drone-nginx; make image
	cd ci/drone-staging; make image

rebuild:
	-docker stack rm nexus
	sleep 20
	-docker rm $(shell docker ps -a -q)
	-docker rmi $(shell docker images -q)
	make images