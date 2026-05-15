SHELL=/bin/bash -o pipefail

BUILD_PRINT = \e[1;34m
END_BUILD_PRINT = \e[0m


ICON_DONE = [✔]
ICON_ERROR = [x]
ICON_WARNING = [!]
ICON_PROGRESS = [-]

NODE ?= $(shell command -v node)
NPM ?= $(shell command -v npm)
NPX ?= $(shell command -v npx)
DOC_BUILD_DIR=docs/build
ANTORA_PLAYBOOK := $(shell pwd)/docs/antora-playbook.local.yml

# ERS repo settings for API docs generation
ERS_REPO_URL ?= https://github.com/OP-TED/entity-resolution-service.git
ERS_REPO_BRANCH ?= develop
ERS_CLONE_DIR = .ers-clone
DOCS_API_PATH ?= $(shell pwd)/docs/modules/ROOT/pages/api-docs

#-----------------------------------------------------------------------------
# API docs generation
#-----------------------------------------------------------------------------
.PHONY: update-api-docs

update-api-docs: ## Regenerate API reference docs from the ERS repo (override: DOCS_API_PATH=<abs>)
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Cloning ERS repo ($(ERS_REPO_BRANCH))$(END_BUILD_PRINT)"
	@ rm -rf $(ERS_CLONE_DIR)
	@ git clone --depth 1 --branch $(ERS_REPO_BRANCH) $(ERS_REPO_URL) $(ERS_CLONE_DIR)
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Installing ERS dependencies$(END_BUILD_PRINT)"
	@ $(MAKE) -C $(ERS_CLONE_DIR) install
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Generating API docs to $(DOCS_API_PATH)$(END_BUILD_PRINT)"
	@ $(MAKE) -C $(ERS_CLONE_DIR) api-docs DOCS_API_PATH=$(DOCS_API_PATH) DOCS_API_REL=$(DOCS_API_PATH)
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Cleaning up$(END_BUILD_PRINT)"
	@ rm -rf $(ERS_CLONE_DIR)
	@ rm -rf "$(DOCS_API_PATH)/ers/.openapi-generator" "$(DOCS_API_PATH)/curation/.openapi-generator" \
		"$(DOCS_API_PATH)/ers/.openapi-generator-ignore" "$(DOCS_API_PATH)/curation/.openapi-generator-ignore"
	@ echo -e "$(BUILD_PRINT)$(ICON_DONE) API docs updated at $(DOCS_API_PATH)/$(END_BUILD_PRINT)"

#-----------------------------------------------------------------------------
# Documentation commands
#-----------------------------------------------------------------------------
build-docs: run-antora

clean-docs:
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Cleaning up Antora build...$(END_BUILD_PRINT)"
	@ rm -rfv $(DOC_BUILD_DIR)
	@ echo -e "$(BUILD_PRINT)$(ICON_DONE) Antora build successfully cleaned!$(END_BUILD_PRINT)"

serve-docs:
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Serving docs at http://localhost:8088 (Ctrl+C to stop)...$(END_BUILD_PRINT)"
	python3 -m http.server 8088 --directory $(DOC_BUILD_DIR)/site

preview-docs: build-docs serve-docs

check-node:
ifeq ($(NODE),)
	@ echo -e "$(BUILD_PRINT)$(ICON_ERROR) Node.js is not installed. Please install Node.js first.$(END_BUILD_PRINT)"
	@ exit 1
else
	@ echo -e "$(BUILD_PRINT)$(ICON_DONE) Node.js is installed: $(NODE)$(END_BUILD_PRINT)"
endif
ifeq ($(NPM),)
	@ echo -e "$(BUILD_PRINT)$(ICON_ERROR) npm is not installed. Please install npm first.$(END_BUILD_PRINT)"
	@ exit 1
else
	@ echo -e "$(BUILD_PRINT)$(ICON_DONE) npm is installed: $(NPM)$(END_BUILD_PRINT)"
endif


install-antora: check-node
	@echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Installing Antora locally...$(END_BUILD_PRINT)"
	npm install antora --save-dev
	npm i -D @sntke/antora-mermaid-extension
	npm install @antora/lunr-extension
	@echo -e "$(BUILD_PRINT)$(ICON_DONE) Antora installed successfully!$(END_BUILD_PRINT)"


init-antora: install-antora
ifeq ($(wildcard package.json),)
	@echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Initializing Node.js project...$(END_BUILD_PRINT)"
	npm init -y
	@echo -e "$(BUILD_PRINT)$(ICON_DONE) package.json created.$(END_BUILD_PRINT)"
else
	@echo -e "$(BUILD_PRINT)$(ICON_DONE) package.json already exists.$(END_BUILD_PRINT)"
endif


run-antora: init-antora
	@echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Running Antora...$(END_BUILD_PRINT)"
	npx antora $(ANTORA_PLAYBOOK)
	@echo -e "$(BUILD_PRINT)$(ICON_DONE) Antora executed successfully!$(END_BUILD_PRINT)"
