ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
VENV := $(ROOT)/.venv
QMK_HOME := $(ROOT)/.qmk_firmware
QMK := $(VENV)/bin/qmk
KEYMAP ?= default
FIRMWARE ?= $(ROOT)/.artifacts/pico_4x4_$(KEYMAP).uf2
DRIVE ?=
DRY_RUN ?= 0

.DEFAULT_GOAL := help
.PHONY: help setup build clean test lint all flash doctor qmk git-init

help: ## Show available commands
	@awk 'BEGIN { FS = ":.*##"; print "Usage: make <target> [VARIABLE=value]"; print ""; print "Targets:" } /^[a-zA-Z0-9_.-]+:.*##/ { printf "  make %-12s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

setup: ## Create/update the Python venv and QMK checkout
	@$(ROOT)/scripts/setup_qmk.sh

build: ## Compile .artifacts/pico_4x4_$(KEYMAP).uf2 (KEYMAP=default|via)
	@$(ROOT)/scripts/build.sh "$(KEYMAP)"

clean: ## Remove QMK build files and generated firmware
	@if [[ -x "$(QMK)" && -d "$(QMK_HOME)/.git" ]]; then \
		(cd "$(QMK_HOME)" && QMK_HOME="$(QMK_HOME)" "$(QMK)" clean -a); \
	fi
	@rm -rf "$(ROOT)/.artifacts"

test: ## Run project-level tests
	@bash $(ROOT)/tests/test_project_layout.sh
	@bash $(ROOT)/tests/test_scripts.sh
	@bash $(ROOT)/tests/test_uploader.sh
	@bash $(ROOT)/tests/test_makefile.sh

lint: setup ## Run QMK metadata lint for the base keyboard
	@mkdir -p "$(QMK_HOME)/keyboards/pico_4x4"
	@cp -a "$(ROOT)/firmware/keyboards/pico_4x4"/. "$(QMK_HOME)/keyboards/pico_4x4"/
	@rm -rf "$(QMK_HOME)/keyboards/pico_4x4/keymaps/via"
	@rm -f "$(QMK_HOME)/keyboards/pico_4x4/via.json"
	@QMK_HOME="$(QMK_HOME)" "$(QMK)" lint -kb pico_4x4 -km default

all: setup test lint build ## Set up, test, lint, and build the firmware

flash: build ## Build and upload firmware to the Pico
	@flash_args=(); \
	if [[ -n "$(DRIVE)" ]]; then flash_args+=(--drive "$(DRIVE)"); fi; \
	if [[ "$(DRY_RUN)" == "1" ]]; then flash_args+=(--dry-run); fi; \
	"$(ROOT)/scripts/upload.sh" "$${flash_args[@]}" "$(FIRMWARE)"

doctor: setup ## Run QMK environment diagnostics
	@QMK_HOME="$(QMK_HOME)" "$(QMK)" doctor

qmk: setup ## Run an arbitrary QMK CLI command, e.g. make qmk ARGS="info -kb pico_4x4"
	@if [[ -z "$(ARGS)" ]]; then \
		echo 'Usage: make qmk ARGS="info -kb pico_4x4"' >&2; \
		exit 2; \
	fi
	@QMK_HOME="$(QMK_HOME)" "$(QMK)" $(ARGS)

git-init: ## Initialize Git metadata in this project
	@git init
