all:

images:
	cd mongo; make image
	cd mongoc; make image
	cd redis; make image
	cd nginx; make image
	cd dev; make image
	cd prod; make image
	cd drone; make image

rebuild:
	-docker stack rm nexus
	sleep 20
	-docker rm $(shell docker ps -a -q)
	-docker rmi $(shell docker images -q)
	make images