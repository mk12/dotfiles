.PHONY: help install lint

help:
	@echo "Targets:"
	@echo "help     show this help message"
	@echo "install  link files to home directory"
	@echo "lint     lint shell files"

install:
	./link.sh

lint:
	shellcheck -s sh -e SC1090 .profile .profile.local
	shellcheck -s bash -e SC1090 .bash_profile .bashrc
	shellcheck patch_vimrc.sh link.sh
