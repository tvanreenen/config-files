# Config Files

My personal macOS application configurations managed with [GNU Stow](https://www.gnu.org/software/stow/).

- [AeroSpace](https://github.com/nikitabobko/AeroSpace): i3-like tiling window manager (`~/.aerospace.toml`)
- [LeaderKey](https://github.com/mikker/LeaderKey): App launcher (`~/Library/Application Support/Leader Key/config.json`)
- [Stats](https://github.com/exelban/stats): System monitor (`~/Library/Preferences/eu.exelban.Stats.plist`)

## Quick Start

```bash
# Full setup (Desktop or Laptop)
just setup-desktop
just setup-laptop
```

## Adding a New Application Config

1. **Option 1** Add the config file manually:

   ```bash
   mkdir -p AppName/Library/Preferences
   cp ~/Library/Preferences/com.example.app.plist AppName/Library/Preferences/
   stow AppName
   ```

2. **Option 2** Add the config with `stow`:

   ```bash
   mkdir -p AppName/Library/Preferences
   touch AppName/Library/Preferences/com.example.app.plist
   stow --adopt AppName
   ```
