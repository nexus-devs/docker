all:

dev:
	cd mongo-rs; make image
	cd redis; make image
	bash run.sh