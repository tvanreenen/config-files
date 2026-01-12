default:
	@just --list --unsorted

install-sketchybar:
	brew tap FelixKratz/formulae
	brew install sketchybar
	brew services start felixkratz/formulae/sketchybar
	stow sketchybar

install-ghostty:
	brew install --cask ghostty
	stow ghostty

install-starship:
	brew install starship
	stow starship

install-aerospace:
	brew install --cask nikitabobko/tap/aerospace
	stow AeroSpace

install-nvim:
	brew install neovim
	stow nvim
	git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
	rm -rf ~/.config/nvim/.git

dry-run PACKAGE:
	stow -n -v {{PACKAGE}}

unstow PACKAGE:
	stow -D {{PACKAGE}}
