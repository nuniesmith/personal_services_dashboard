SHELL := /bin/bash
PROJECT := 7gram
COMPOSE := docker/docker-compose.yml
SUBMODULE := shared-nginx

.PHONY: help init up down logs pull update-submodule lint

help:
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialize submodules and copy env if missing
	@if [ ! -d $(SUBMODULE) ]; then echo "Adding nginx submodule"; git submodule add ../../shared/nginx $(SUBMODULE) || true; fi
	git submodule update --init --recursive
	@if [ ! -f .env ] && [ -f .env.example ]; then cp .env.example .env; fi

up: init ## Start stack
	bash scripts/dev-up.sh

down: ## Stop stack
	bash scripts/dev-down.sh

logs: ## Tail logs
	@if [ -f $(SUBMODULE)/docker-compose.simple.yml ]; then COMP=$(SUBMODULE)/docker-compose.simple.yml; else COMP=$(SUBMODULE)/docker-compose.yml; fi; \
	docker compose -f $$COMP logs -f --tail=200

pull: ## Pull latest images for base services
	@if [ -f $(SUBMODULE)/docker-compose.simple.yml ]; then COMP=$(SUBMODULE)/docker-compose.simple.yml; else COMP=$(SUBMODULE)/docker-compose.yml; fi; \
	docker compose -f $$COMP pull

update-submodule: ## Update nginx submodule to latest main
	cd $(SUBMODULE) && git fetch origin && git checkout main && git pull --ff-only
	git add $(SUBMODULE)
	@echo "Submodule updated; commit to lock the new revision."

lint: ## Placeholder lint target
	@echo "Add frontend lint tooling here"
