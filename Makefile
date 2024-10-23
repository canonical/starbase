PROJECT=starcraft
SOURCES=$(wildcard *.py) $(PROJECT) tests
DOCS=docs

ifneq ($(OS),Windows_NT)
	OS := $(shell uname)
endif

.DEFAULT_GOAL := help

.ONESHELL:

.SHELLFLAGS = -ec

.PHONY: help
help: ## Show this help.
	@printf "%-41s %s\n" "Target" "Description"
	@printf "%-41s %s\n" "------" "-----------"
	@fgrep " ##" $(MAKEFILE_LIST) | fgrep -v grep | sed 's/:[^#]*/ /' | awk -F '[: ]*' \
	'{
		if ($$2 == "##")
		{
			$$1=sprintf("%-40s", $$1);
			$$2="";
			print $$0;
		}
		else
		{
			$$1=sprintf(" └%-38s", $$1);
			$$2="";
			print $$0;
		}
	}'

---------------- : ## ----------------

.PHONY: setup
setup: install-uv setup-precommit ## Set up a development environment
	uv sync --frozen --all-extras

.PHONY: setup-tests
setup-tests: install-uv  ##- Set up a testing environment without linters
	uv sync --frozen

.PHONY: setup-lint
setup-lint: install-uv install-shellcheck  ##- Set up a linting-only environment
	uv sync --frozen --no-dev --no-install-workspace --extra lint --extra types

.PHONY: setup-docs
setup-docs: install-uv  ##- Set up a documentation-only environment
	uv sync --frozen --no-dev --no-install-workspace --extra docs

.PHONY: setup-precommit
setup-precommit: install-uv  ##- Set up pre-commit hooks in this repository.
ifeq ($(shell which pre-commit),)
	uv tool install pre-commit
endif
	pre-commit install

---------------- : ## ----------------

.PHONY: format
format: format-ruff format-codespell  ## Run all automatic formatters

.PHONY: format-ruff
format-ruff:  ##- Automatically format with ruff
	success=true
	ruff check --fix $(SOURCES) || success=false
	ruff format $(SOURCES)
	$$success || exit 1

.PHONY: format-codespell
format-codespell:  ##- Fix spelling issues with codespell
	uv run codespell --toml pyproject.toml --write-changes $(SOURCES)

.PHONY: autoformat
autoformat: format  # Alias for 'format'

---------------- : ## ----------------

.PHONY: lint
lint: lint-ruff lint-codespell lint-mypy lint-pyright lint-shellcheck lint-yaml lint-docs  ## Run all linters

.PHONY: lint-ruff
lint-ruff: install-ruff  ##- Lint with ruff
	ruff check $(SOURCES)
	ruff format --diff $(SOURCES)

.PHONY: lint-codespell
lint-codespell: install-codespell  ##- Check spelling with codespell
	uv run codespell --toml pyproject.toml $(SOURCES)

.PHONY: lint-mypy
lint-mypy:  ##- Check types with mypy
	uv run mypy --show-traceback --show-error-codes $(PROJECT)

.PHONY: lint-pyright
lint-pyright:  ##- Check types with pyright
ifneq ($(shell which pyright),) # Prefer the system pyright
	pyright --pythonpath .venv/bin/python
else
	# Fix for a bug in npm
	[ -d "/home/ubuntu/.npm/_cacache" ] && chown -R 1000:1000 "/home/ubuntu/.npm" || true
	uv run pyright
endif

.PHONY: lint-shellcheck
lint-shellcheck: install-shellcheck  ##- Lint shell scripts
	git ls-files | file --mime-type -Nnf- | grep shellscript | cut -f1 -d: | xargs -r shellcheck

.PHONY: lint-yaml
lint-yaml:  ##- Lint YAML files with yamllint
	uv run --extra lint yamllint .

.PHONY: lint-docs
lint-docs:  ##- Lint the documentation
	uv run --extra docs sphinx-lint --max-line-length 88 --enable all $(DOCS)

---------------- : ## ----------------

.PHONY: test
test: test-unit test-integration  ## Run all tests

.PHONY: test-unit
test-unit:  ##- Run unit tests
	uv run pytest tests/unit

.PHONY: test-integration
test-integration:  ##- Run integration tests
	uv run pytest tests/integration

.PHONY: coverage
coverage:  ## Generate coverage report
	uv run coverage run --source $(PROJECT) -m pytest tests/unit
	uv run coverage xml -o coverage.xml
	uv run coverage report -m
	uv run coverage html

---------------- : ## ----------------

.PHONY: docs
docs:  ## Build documentation
	uv run --extra docs sphinx-build -b html -W docs docs/_build

.PHONY: docs-auto
docs-auto:  ## Build and host docs with sphinx-autobuild
	uv run --extra docs sphinx-autobuild -b html --open-browser --port=8080 --watch $(PROJECT) -W docs docs/_build

---------------- : ## ----------------

.PHONY: package
package: package-pip  ## Build all packages

.PHONY: package-pip
package-pip:  ##- Build packages for pip (sdist, wheel)
	uv run pyproject-build --installer uv .

.PHONY: package-snap
package-snap: snap/snapcraft.yaml  ##- Build snap package
ifeq ($(shell which snapcraft),)
	sudo snap install --classic snapcraft
endif
	snapcraft pack

.PHONY: publish
publish: publish-pypi  ## Publish packages

.PHONY: publish-pypi
publish-pypi: clean package-pip  ##- Publish Python packages to pypi
	uv tool run twine check dist/*
	uv tool run twine upload dist/*

---------------- : ## ----------------

.PHONY: clean
clean:  ## Clean up the development environment
	uv tool run pyclean .
	rm -rf dist/ build/ docs/_build/ *.snap .coverage*

---------------- : ## ----------------

# Below are intermediate targets for setup. They are not included in help as they should
# not be used independently.

.PHONY: install-uv
install-uv:
ifneq ($(shell which uv),)
else ifneq ($(shell which snap),)
	sudo snap install --classic astral-uv
else ifneq ($(shell which brew),)
	brew install uv
else ifeq ($(OS),Windows_NT)
	pwsh -c "irm https://astral.sh/uv/install.ps1 | iex"
else
	curl -LsSf https://astral.sh/uv/install.sh | sh
endif

.PHONY: install-codespell
install-codespell:
ifneq ($(shell which codespell),)
else ifneq ($(shell which snap),)
	sudo snap install codespell
else ifneq ($(shell which brew),)
	make install-uv
	uv tool install codespell
endif

.PHONY: install-ruff
install-ruff:
ifneq ($(shell which ruff),)
else ifneq ($(shell which snap),)
	sudo snap install ruff
else
	make install-uv
	uv tool install ruff
endif

.PHONY: install-shellcheck
install-shellcheck:
ifneq ($(shell which shellcheck),)
else ifneq ($(shell which snap),)
	sudo snap install shellcheck
else ifneq ($(shell which brew),)
	brew install shellcheck
endif
