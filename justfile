default:
	@just --list --unsorted

setup-desktop:
	stow AeroSpace
	stow ghostty
	@echo "Skipping stow of Stats, config must be imported through UI"

setup-laptop:
	stow ghostty
	@echo "Skipping stow of Stats, config must be imported through UI"

dry-run PACKAGE:
	stow -n -v {{PACKAGE}}

unstow PACKAGE:
	stow -D {{PACKAGE}}
