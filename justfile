default:
	@just --list --unsorted

setup-desktop:
	stow AeroSpace
	stow stats-desktop

setup-laptop:
	stow stats-laptop

dry-run PACKAGE:
	stow -n -v {{PACKAGE}}

unstow PACKAGE:
	stow -D {{PACKAGE}}
