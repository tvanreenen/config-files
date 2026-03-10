default:
	@just --list --unsorted

stow:
	stow frame
	stow ghostty
	stow nvim
	stow sketchybar
	stow starship
	stow zsh

init-nvim:
	git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
	rm -rf ~/.config/nvim/.git

init-sketchybar:
	brew services start felixkratz/formulae/sketchybar
