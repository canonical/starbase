PROJECT=starcraft

include common.mk

.PHONY: format
format: format-ruff format-codespell  ## Run all automatic formatters

.PHONY: lint
lint: lint-ruff lint-codespell lint-mypy lint-pyright lint-shellcheck lint-yaml lint-docs lint-twine  ## Run all linters

.PHONY: pack
pack: pack-pip  ## Build all packages

.PHONY: pack-snap
pack-snap: snap/snapcraft.yaml  ##- Build snap package
ifeq ($(shell which snapcraft),)
	sudo snap install --classic snapcraft
endif
	snapcraft pack

.PHONY: publish
publish: publish-pypi  ## Publish packages

.PHONY: publish-pypi
publish-pypi: clean package-pip lint-twine  ##- Publish Python packages to pypi
	uv tool run twine upload dist/*

# Used for installing build dependencies in CI.
.PHONY: install-build-deps
install-build-deps:
ifeq ($(shell which apt-get),)
	$(warning Cannot install build dependencies without apt.)
	$(warning Cannot install build dependencies on non-linux platforms.)
else ifeq ($(wildcard /usr/include/libxml2/libxml/xpath.h),)
	sudo apt-get install libxml2-dev libxslt1-dev
else ifeq ($(wildcard /usr/include/libxslt/xslt.h),)
	sudo apt-get install libxslt1-dev
endif
