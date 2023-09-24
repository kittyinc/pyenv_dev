IMAGE_TAG_NAME=pyenvdev
export IMAGE_NAME=$(IMAGE_TAG_NAME):latest

build:
	docker buildx build -t $(IMAGE_TAG_NAME) --output type=tar,dest=pyenvdev_latest.tar .
