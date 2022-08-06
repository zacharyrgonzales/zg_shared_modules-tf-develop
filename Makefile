SHELL               := /bin/bash
MODULES             := $(shell git show --name-only --oneline ${CIRCLE_SHA1} | awk -F"/" '/^modules\// {print $$2}' | grep -v README | sort -u)
ALL_MODULES         := $(shell find ./modules -path "./modules/*/main.tf" -print | cut -d/ -f3 | sort -u | tr "\n" " ")

DOCKER_REGISTRY_URL  = docker.internal-zg.com
DOCKER_IMAGE_TAG     = latest

TERRAFORM_TOOLS := docker run \
	-it \
	--rm \
	-v $(PWD)/.:/terraform \
	-v $(HOME)/.aws:/root/.aws \
	-v $(HOME)/.ssh:/root/.ssh \
	-e GIT_BRANCH="${SHARED_MODULES_BRANCH}" \
	-e MODULES="${MODULES}" \
	-e ALL_MODULES="${ALL_MODULES}" \
	-e GKE_DEFAULT_ZONE="us-west1" \
	-e ENV="${ENV}" \
	${DOCKER_REGISTRY_URL}/ops/terraform-tools:${DOCKER_IMAGE_TAG}


.PHONY: modules
modules: ## display what modules will be applied to
	@echo ${MODULES}

.PHONY: all-modules
all-modules: ## generates a list of all modules
	@echo ${ALL_MODULES}

.PHONY: prepare
prepare: clean validate fmt-write documentation ## runs pre-commit tasks

.PHONY: clean
clean: ## remove all .terraform directories
	@find . -name .terraform | xargs rm -rf; \
	find . -name .terraform.lock.hcl | xargs rm -rf

.PHONY: validate
validate: clean pull ## run terraform validate on all the modules
	@${TERRAFORM_TOOLS} validate;

.PHONY: fmt
fmt: pull ## run terraform fmt on all the terraform files
	@${TERRAFORM_TOOLS} fmt;


.PHONY: fmt-write
fmt-write: pull ## run terraform fmt -write=true on all the terraform files
	@${TERRAFORM_TOOLS} fmt-write;

.PHONY: documentation
documentation: pull ## generate documentation using terraform-docs
	@${TERRAFORM_TOOLS} docs;