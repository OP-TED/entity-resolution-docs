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

#-----------------------------------------------------------------------------
# Documentation commands
#-----------------------------------------------------------------------------
build-docs: run-antora

clean-docs:
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Cleaning up Antora build...$(END_BUILD_PRINT)"
	@ rm -rfv $(DOC_BUILD_DIR)
	@ echo -e "$(BUILD_PRINT)$(ICON_DONE) Antora build successfully cleaned!$(END_BUILD_PRINT)"

serve-docs:
	@ echo -e "$(BUILD_PRINT)$(ICON_PROGRESS) Serving docs at http://localhost:8080 (Ctrl+C to stop)...$(END_BUILD_PRINT)"
	python3 -m http.server 8080 --directory $(DOC_BUILD_DIR)/site

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
