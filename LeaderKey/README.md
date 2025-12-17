# LeaderKey Configuration

This is a personal configuration file for [LeaderKey](https://github.com/mikker/LeaderKey), a macOS app launcher that lets you launch applications quickly using a leader key pattern. Press your configured leader key to bring up grouped application menus, then a subsequent key to launch your chosen app—all via fast keyboard shortcuts.

## Installation

### Prerequisites

1. **Install LeaderKey**:
   - Install via Homebrew: `brew install leader-key`

2. **Locate LeaderKey's config directory**:
   - The configuration file is stored at:
     `~/Library/Application\ Support/Leader\ Key/config.json`

### Setup

#### Option 1: Symbolic Link (Recommended for Syncing)

This method keeps your configuration in sync with this repository:

```bash
# Navigate to the config-files directory
cd ~/.config/config-files  # or wherever you cloned this repo

# Backup existing config (if any)
mv ~/Library/Application\ Support/LeaderKey/config.json ~/Library/Application\ Support/LeaderKey/config.json.backup

# Create symbolic link
ln -s "$(pwd)/LeaderKey/config.json" ~/Library/Application\ Support/LeaderKey/config.json
```

#### Option 2: Copy Configuration

If you prefer to copy the file instead:

```bash
# Copy the config file
cp LeaderKey/config.json ~/Library/Application\ Support/LeaderKey/config.json
```

### Restart LeaderKey

After setting up the configuration:

1. Quit LeaderKey (if it's running)
2. Relaunch LeaderKey
3. The new configuration should be loaded

## Usage

Once configured, use LeaderKey like this:

1. **Press the leader key** (default is usually configured in LeaderKey settings)
2. **Press the group key** (e.g., `b` for Browse, `c` for Code)
3. **Press the application key** (e.g., `s` for Safari, `t` for Terminal)

Example: To open Safari, you might press: `Leader Key` → `b` → `s`

## Configuration File Structure

The `config.json` follows this structure:

```json
{
  "type": "group",
  "actions": [
    {
      "type": "group",
      "key": "group-key",
      "label": "Group Label",
      "iconPath": "icon.name",
      "actions": [
        {
          "type": "application",
          "key": "app-key",
          "value": "/path/to/Application.app"
        }
      ]
    }
  ]
}
```
