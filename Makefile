IMAGE_NAME=sineverba/testphp74xc
CONTAINER_NAME=testphp74xc
VERSION=1.7.0-dev

build:
		docker build --tag $(IMAGE_NAME):$(VERSION) .

multiple:
		docker buildx build --tag $(IMAGE_NAME) --platform linux/386,linux/amd64,linux/arm/v6,linux/arm/v7 --push .

test:
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -v | grep 7.4.29
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -v | grep OPcache
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -m | grep xdebug
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -r "xdebug_info();" | grep "3.1.4"
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -m | grep pdo_pgsql
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -m | grep zip
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -m | grep mcrypt
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) /usr/bin/composer -V | grep "1.10.26"
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -i | grep "short_open_tag => Off => Off"
		@docker run --name $(CONTAINER_NAME) --rm $(IMAGE_NAME):$(VERSION) php -i | grep "memory_limit => 512M => 512M"

destroy:
		docker image rm $(IMAGE_NAME):$(VERSION)