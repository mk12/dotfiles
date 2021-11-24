shell_files := \
	.profile .profile.local .bash_profile .bashrc patch_vimrc.sh link.sh

.PHONY: help install lint

help:
	@echo "Targets:"
	@echo "help     show this help message"
	@echo "install  link files to home directory"
	@echo "lint     lint shell files"

install:
	@./link.sh -cy

lint:
	shellcheck $(shell_files)
