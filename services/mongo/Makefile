all:

pass:
	pwgen -s 64 1 > admin-pwd
	docker secret create mongo-admin-pwd admin-pwd
	rm admin-pwd

keyfile:
	openssl rand -base64 756 > keyfile
	docker secret create mongo-keyfile keyfile
	rm keyfile

image:
	make deps
	docker build -t $(registry)/mongo .
	docker push $(registry)/mongo

deps:
	bash util/check-keyfile.sh
	bash util/check-admin-pwd.sh
