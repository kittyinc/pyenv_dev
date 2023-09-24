TOKEN ?=
IMAGE_TAG_NAME=pyenv_dev
AUTHOR=kittyinc
export IMAGE_NAME=$(IMAGE_TAG_NAME):latest

build:
	docker build -t ghcr.io/$(AUTHOR)/$(IMAGE_TAG_NAME):latest .

buildtar:
	docker build -t ghcr.io/$(AUTHOR)/$(IMAGE_TAG_NAME):latest --output type=tar,dest=pyenvdev_latest.tar .

push: build dockerlogin
	docker push ghcr.io/$(AUTHOR)/$(IMAGE_TAG_NAME):latest

dockerlogin:
	docker login --username $(AUTHOR) --password $(TOKEN) ghcr.io