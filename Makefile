all:

images:
	cd mongodb; make image
	cd redis; make image
	cd app; make image
	bash run.sh