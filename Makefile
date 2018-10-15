# If the USE_SUDO_FOR_DOCKER env var is set, prefix docker commands with 'sudo'
ifdef USE_SUDO_FOR_DOCKER
	SUDO_CMD = sudo
endif

IMAGE ?= asia.gcr.io/k8s-project-199813/osbapi-app
TAG ?= $(shell git describe --tags --always)
PULL ?= Never

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
	helm upgrade --install app-skeleton --namespace app-skeleton \
	charts/osbapiapp \
	--set image.repository="$(IMAGE)",image.tag="$(TAG)",image.pullPolicy="$(PULL)"

remove-app: ## Removes app with helm
	helm delete --purge app-skeleton

create-ns: ## Creates a namespace
	kubectl create ns app-skeleton

remove-ns: ## Removes a namespace
	kubectl delete ns app-skeleton

provision-svc: create-ns ## Provisions a service instance
	kubectl apply -f manifests/service-instance.yaml

unprovision-svc: ## Removes a service instance
	kubectl delete -f manifests/service-instance.yaml

bind-svc: ## Creates a binding
	kubectl apply -f manifests/service-binding.yaml

unbind-svc: ## Removes a binding
	kubectl delete -f manifests/service-binding.yaml

help: ## Shows the help
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
        awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''

.PHONY: build linux image clean push deploy-app remove-app create-ns remove-ns provision-svc unprovision-svc bind-svc unbind-svc help
