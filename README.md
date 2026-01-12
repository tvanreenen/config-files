# Config Files

This repository contains configuration files for various tools and applications, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Active Configurations

- **[SketchyBar](https://github.com/FelixKratz/SketchyBar)** - Transparent macOS menu bar replacement with system monitoring widgets
- **[Ghostty](https://github.com/mitchellh/ghostty)** - Terminal emulator configuration
- **[Starship](https://starship.rs/)** - Cross-shell prompt
- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** - i3-like tiling window manager for macOS
- **[Neovim](https://neovim.io/)** - Hyperextensible Vim-based text editor

## Usage

Install configurations using [`just`](https://github.com/casey/just):

```bash
just install-sketchybar
just install-ghostty
just install-starship
just install-aerospace
just install-nvim
```

If you already have Neovim configured, use `adopt-nvim` to adopt existing config:
```bash
just adopt-nvim
```

Each command installs the tool via Homebrew and then runs `stow` to symlink the configuration files.

## Stow Management

- `just dry-run PACKAGE` - Preview what stow would do
- `just unstow PACKAGE` - Remove symlinks for a package
