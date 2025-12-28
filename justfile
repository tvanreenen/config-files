default:
	@just --list --unsorted

setup-desktop:
	stow AeroSpace
	stow ghostty
	stow stats-desktop

setup-laptop:
	stow ghostty
	stow stats-laptop

dry-run PACKAGE:
	stow -n -v {{PACKAGE}}

unstow PACKAGE:
	stow -D {{PACKAGE}}
