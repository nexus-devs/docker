all:

images:
	cd mongo; make image
	cd mongoc; make image
	cd redis; make image
	cd nginx; make image
	cd dev; make image
	cd prod; make image