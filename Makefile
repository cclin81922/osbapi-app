# If the USE_SUDO_FOR_DOCKER env var is set, prefix docker commands with 'sudo'
ifdef USE_SUDO_FOR_DOCKER
	SUDO_CMD = sudo
endif

IMAGE ?= asia.gcr.io/k8s-project-199813/osbapi-app
TAG ?= $(shell git describe --tags --always)
PULL ?= IfNotPresent

build: ## Builds the app
	go build -i github.com/cclin81922/osbapi-app/cmd/osbapiapp

linux: ## Builds a Linux executable
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
	go build -o osbapiapp-linux --ldflags="-s" github.com/cclin81922/osbapi-app/cmd/osbapiapp

image: linux ## Builds a Linux based image
	cp osbapiapp-linux image/osbapiapp
	$(SUDO_CMD) docker build image/ -t "$(IMAGE):$(TAG)"

clean: ## Cleans up build artifacts
	rm -f osbapiapp
	rm -f osbapiapp-linux
	rm -f image/osbapiapp

push: image ## Pushes the image to dockerhub, REQUIRES SPECIAL PERMISSION
	$(SUDO_CMD) docker push "$(IMAGE):$(TAG)"

deploy-app: image ## Deploys app with helm
	app upgrade --install app-skeleton --namespace app-skeleton \
	charts/osbapiapp \
	--set image.repository="$(IMAGE)",image.tag=="$(TAG)",image.pullPolicy="$(PULL)"

remove-app: ## Removes app with helm
	helm delete --purge app-skeleton
	kubectl delete ns app-skeleton

help: ## Shows the help
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
        awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''

.PHONY: build linux image clean push deploy-app remove-app help
