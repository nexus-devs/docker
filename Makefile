all:

dev:
	cd mongo-rs; make image
	cd redis; make image
	cd app; make image
	bash run.sh