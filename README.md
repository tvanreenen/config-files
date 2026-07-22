# Config Files

Personal macOS configuration managed with
[GNU Stow](https://www.gnu.org/software/stow/) and
[Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile).

## Managed configuration

- `agents` — shared agent skills
- `codex` — Codex configuration and skills
- `frame` — [Frame](https://github.com/tvanreenen/frame) window manager
- `ghostty` — [Ghostty](https://github.com/ghostty-org/ghostty) terminal
- `nvim` — [Neovim](https://neovim.io/) configuration
- `sketchybar` — [SketchyBar](https://github.com/FelixKratz/SketchyBar)
- `starship` — [Starship](https://starship.rs/) shell prompt
- `zshrc` — [Zsh](https://www.zsh.org/) shell configuration
- `Brewfile` — command-line tools and macOS applications

## Setup

Install [Homebrew](https://brew.sh/), then install the declared dependencies and
link the configuration into the home directory:

```sh
brew bundle
just stow
```

The repository's `.stowrc` sets the Stow target to the home directory. Run
`just --list` to see the remaining setup helpers.

## Cloudflare Tunnel

Homebrew installs and upgrades `cloudflared`, but the `home` tunnel runs as the
system LaunchDaemon `com.cloudflare.cloudflared` so it starts at boot. Do not run
`brew services start cloudflared`; that creates an unconfigured per-user service.

For a new machine, set `TUNNEL_TOKEN` from a secure source and install the
boot-time service:

```sh
sudo cloudflared service install "$TUNNEL_TOKEN"
unset TUNNEL_TOKEN
```

After upgrading `cloudflared`, restart the service and verify the tunnel:

```sh
sudo launchctl kickstart -k system/com.cloudflare.cloudflared
cloudflared tunnel info home
```

Keep the tunnel token and generated LaunchDaemon plist out of this repository.
