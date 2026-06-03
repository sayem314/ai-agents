# ai-agents — build and publish Docker image matrix

SHELL := /bin/bash

include docker/tool-versions.mk

TOOLS    := codex claude opencode
LANGS    := node python go rust java full
TAG      ?= latest
REGISTRY ?= sayem314/ai-agents
PLATFORMS ?= linux/amd64,linux/arm64
BAKE_FILE := docker-bake.hcl

TOOL ?= codex
LANG ?= full

lang_image  = ai-agents-lang-$(1):$(TAG)
image_name  = ai-agents-$(1)-$(2):$(TAG)

.PHONY: help build-lang build bake publish publish-all

help:
	@echo "ai-agents — Docker CLI sandboxes for AI coding agents"
	@echo ""
	@echo "Local (single-arch, loads into docker — best for testing):"
	@echo "  make build-lang LANG=node"
	@echo "  make build TOOL=codex LANG=full"
	@echo ""
	@echo "Matrix (buildx, one image at a time, current arch):"
	@echo "  make bake                  All 18 tool images, sequential"
	@echo "  make bake TARGET=codex-full   One target"
	@echo ""
	@echo "Publish (buildx, multi-arch $(PLATFORMS) per image, sequential):"
	@echo "  make publish TOOL=codex LANG=full"
	@echo "  make publish-all"
	@echo ""
	@echo "Variables: TOOL, LANG, TAG, TARGET, REGISTRY=$(REGISTRY), PLATFORMS"

build-lang:
	@test -n "$(LANG)" || (echo "LANG is required" && exit 1)
	docker build -t $(call lang_image,$(LANG)) -f docker/langs/$(LANG)/Dockerfile .

build:
	@test -n "$(TOOL)" && test -n "$(LANG)" || (echo "TOOL and LANG are required" && exit 1)
	$(MAKE) build-lang LANG=$(LANG) TAG=$(TAG)
	docker build \
		--build-context lang=docker-image://$(call lang_image,$(LANG)) \
		--build-arg CODEX_VERSION=$(CODEX_VERSION) \
		--build-arg CLAUDE_VERSION=$(CLAUDE_VERSION) \
		--build-arg OPENCODE_VERSION=$(OPENCODE_VERSION) \
		-t $(call image_name,$(TOOL),$(LANG)) \
		-f docker/tools/$(TOOL)/Dockerfile .

# One target via bake, or full matrix one-by-one (lang deps via bake contexts).
bake:
ifdef TARGET
	TAG=$(TAG) docker buildx bake -f $(BAKE_FILE) $(TARGET)
else
	@set -e; \
	for tool in $(TOOLS); do \
	  for lang in $(LANGS); do \
	    echo "==> $$tool-$$lang"; \
	    TAG=$(TAG) docker buildx bake -f $(BAKE_FILE) $$tool-$$lang; \
	  done; \
	done
endif

# Multi-arch push for one Hub tag (amd64 + arm64 in parallel within that build).
# Hub tags: floating name (e.g. codex, codex-node) + optional version suffix when pinned.
publish:
	@test -n "$(TOOL)" && test -n "$(LANG)" || (echo "TOOL and LANG are required" && exit 1)
	REGISTRY=$(REGISTRY) TAG=$(TAG) \
		CODEX_VERSION=$(CODEX_VERSION) CLAUDE_VERSION=$(CLAUDE_VERSION) OPENCODE_VERSION=$(OPENCODE_VERSION) \
		docker buildx bake -f $(BAKE_FILE) \
		--set "*.platform=$(PLATFORMS)" \
		--push \
		$(TOOL)-$(LANG)

publish-all:
	@set -e; \
	for tool in $(TOOLS); do \
	  for lang in $(LANGS); do \
	    echo "==> publish $$tool-$$lang"; \
	    $(MAKE) publish TOOL=$$tool LANG=$$lang TAG=$(TAG) REGISTRY=$(REGISTRY) PLATFORMS="$(PLATFORMS)"; \
	  done; \
	done
