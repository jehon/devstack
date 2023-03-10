#!/usr/bin/env make

#
# Dependencies:
#
#   scripts <= packages <= dockers <= integration tests
#

all: clear clean dump lint build test ok

# https://stackoverflow.com/a/26936855/1954789
# https://stackoverflow.com/a/39420097/1954789
SHELL=/bin/bash -o pipefail -o errexit

# Locale per default
LANG=C.UTF-8

# .ONESHELL:
.SECONDEXPANSION:

ABS_ROOT = $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
TMP_ROOT = tmp
PRJ_PUBLISH=$(TMP_ROOT)/publish

export PATH := $(ABS_ROOT)/.python/bin:$(PATH)
export PYTHONPATH := $(ABS_ROOT)/.python:$(PYTHONPATH)

define mkdir
	@mkdir -p "$(dir $(1))"
endef

define touch
	$(call mkdir,$(1))
	@touch "$(1)"
endef

define copy
	$(call mkdir,$(1))
	@cp -fv "$(2)" "$(1)"
endef

DUMP_ALIGN=40
define dump_info
@if [ -n "$(2)" ]; then \
	printf "* %-$(DUMP_ALIGN)s %s\n" '$(1): ' '$(2)'; \
else \
	printf "* %-$(DUMP_ALIGN)s %s\n" '$(1): ' '$($(1))'; \
fi
endef

define dump_version
@printf "* %-$(DUMP_ALIGN)s %s\n" '$(shell type $(1)): ' '$(shell $(1) --version | head -n $(if $2,$2,1) | tail -n 1)' 
endef

define dump_title
@printf "**************************** $(1) **************************\n"
endef

define dump_space
@printf "*\n"
endef

#
#
# Generic targets
#
#
.PHONY: dump
dump:
	$(call dump_space)
	$(call dump_title,GLOBAL)
	$(call dump_info,PWD,$(shell pwd))
	$(call dump_info,ROOT)
	$(call dump_info,TMP_ROOT)
	$(call dump_info,PRJ_PUBLISH)
	$(call dump_info,PATH)
	$(call dump_info,PYTHONPATH)
	$(call dump_space)

.PHONY: clean
clean: 
	rm -fr tmp

.PHONY: build
build:
	@true

.PHONY: test
test:
	@true

.PHONY: lint
lint:
	@true

.PHONY: release
release: release-version
#	/usr/bin/jh-github-publish-pages "$(PRJ_PUBLISH)" "push"

release-version:
	rm -fr "$(PRJ_PUBLISH)"
	mkdir -p "$(PRJ_PUBLISH)"
	date > "$(PRJ_PUBLISH)"/version.txt

#
#
# Helpers
#
#
.PHONY: clear
clear:
	clear

.PHONY: ok
ok:
	@echo "Ok: done"

# target 'start' could not exists, since it is the name of a file

clean-force: clean
# Thanks to https://stackoverflow.com/a/46273201/1954789
	git clean -dfX

#######################################
#
# Global receipes
#

$(TMP_ROOT):
	mkdir -p "$@"

node_modules/.built: package-lock.json package.json
	npm ci
	$(call touch,$@)

#######################################
#
# External makefiles
#

include Makefile.ansible
include Makefile.synology
