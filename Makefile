shell_files := $(wildcard *.sh) $(wildcard .*profile) .bashrc

define usage
Targets:
	help     Show this help message
	install  Link files in home directory
	lint     Lint shell files
endef

.PHONY: help install lint

help:
	$(info $(usage))
	@:

install:
	@./install.sh -cy

lint:
	shellcheck $(shell_files)
