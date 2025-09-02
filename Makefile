SHELL := /bin/bash
DOTDIR := $(shell pwd)
PKGS := kitty starship zsh bin

.PHONY: help bootstrap stow restow unstow check deps

help:
	@echo "Targets:"
	@echo "  bootstrap  - stow all packages"
	@echo "  stow       - stow $(PKGS)"
	@echo "  restow     - restow $(PKGS)"
	@echo "  unstow     - unstow $(PKGS)"
	@echo "  check      - validate symlinks/scripts"
	@echo "  deps       - print suggested dependencies"

bootstrap: stow

stow:
	./scripts/bootstrap.sh $(PKGS)

restow:
	./scripts/bootstrap.sh --restow $(PKGS)

unstow:
	./scripts/bootstrap.sh --unstow $(PKGS)

check:
	./scripts/check.sh

deps:
	@echo "Suggested deps: kitty zsh starship stow fzf ripgrep bat delta eza fd zoxide"
