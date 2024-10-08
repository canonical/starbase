PROJECT=starcraft
SOURCES=$(wildcard *.py) $(PROJECT) tests
DOCS=docs

ifneq ($(OS),Windows_NT)
	OS := $(shell uname)
endif

.PHONY: help
help: ## Show this help.
	@printf "%-30s %s\n" "Target" "Description"
	@printf "%-30s %s\n" "------" "-----------"
	@fgrep " ## " $(MAKEFILE_LIST) | fgrep -v grep | awk -F ': .*## ' '{$$1 = sprintf("%-30s", $$1)} 1'

.PHONY: setup
setup: ## Set up a development environment
ifeq ($(OS),Linux)
	sudo snap install codespell ruff shellcheck
	sudo snap install --classic astral-uv
	sudo apt-get --yes install libxml2-dev libxslt-dev
else ifeq ($(OS),Windows_NT)
	pipx install uv
	choco install shellcheck
else ifeq ($(OS),Darwin)
	brew install uv
	brew install shellcheck
endif
ifneq ($(OS),Linux)
	uv tool install --upgrade codespell
	uv tool install --upgrade ruff
endif
	uv tool install --upgrade yamllint
	uv tool update-shell

.PHONY: setup-precommit
setup-precommit:  ## Set up pre-commit hooks in this repository.
	uvx pre-commit install

.PHONY: autoformat
autoformat: format-ruff format-codespell  ## Run all automatic formatters

.PHONY: lint
lint: lint-ruff lint-codespell lint-mypy lint-pyright lint-yaml  ## Run all linters

.PHONY: test
test: test-unit test-integration  ## Run all tests with the default python

.PHONY: docs
docs: ## Build documentation
	uv run --frozen --extra docs sphinx-build -b html -W docs docs/_build

.PHONY: docs-auto
docs-auto:  ## Build and host docs with sphinx-autobuild
	uv run --frozen --extra docs sphinx-autobuild -b html --open-browser --port=8080 --watch $(PROJECT) -W docs docs/_build

.PHONY: format-codespell
format-codespell:  ## Fix spelling issues with codespell
	codespell --toml pyproject.toml --write-changes $(SOURCES)

.PHONY: format-ruff
format-ruff:  ## Automatically format with ruff
	ruff format $(SOURCES)
	ruff check --fix $(SOURCES)

.PHONY: lint-codespell
lint-codespell: ## Check spelling with codespell
	codespell --toml pyproject.toml $(SOURCES)

.PHONY: lint-docs
lint-docs:  ## Lint the documentation
	uv run --frozen --extra docs sphinx-lint --enable all $(DOCS)

.PHONY: lint-mypy
lint-mypy: ## Check types with mypy
	uv run mypy $(PROJECT)

.PHONY: lint-pyright
lint-pyright: ## Check types with pyright
	uv run pyright $(SOURCES)

.PHONY: lint-ruff
lint-ruff:  ## Lint with ruff
	ruff format --diff $(SOURCES)
	ruff check $(SOURCES)

.PHONY: lint-shellcheck
lint-shellcheck:
	sh -c 'git ls-files | file --mime-type -Nnf- | grep shellscript | rev | cut -d: -f2- | rev | xargs -r shellcheck'

.PHONY: lint-yaml
lint-yaml:  ## Lint YAML files with yamllint
	yamllint .

.PHONY: test-unit
test-unit: ## Run unit tests
	uv run --frozen pytest --cov=$(PACKAGE) --cov-config=pyproject.toml --cov-report=xml:.coverage.unit.xml --junit-xml=.results.unit.xml tests/unit

.PHONY: test-integration
test-integration:  ## Run integration tests
	uv run --frozen pytest --cov=$(PACKAGE) --cov-config=pyproject.toml --cov-report=xml:.coverage.integration.xml --junit-xml=.results.integration.xml tests/integration
