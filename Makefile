all:

images:
	cd mongo; make image
	cd mongoc; make image