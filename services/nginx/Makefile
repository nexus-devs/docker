all:

image:
	docker build -t $(registry)/nginx .

publish:
	docker push $(registry)/nginx
