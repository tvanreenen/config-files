# Stats Configuration

Personal configuration file for [Stats](https://github.com/exelban/stats) - a macOS system monitor for the menu bar.

## Configuration File

The `Stats.plist` file contains preferences and settings for the Stats application.

## Usage

### Syncing Across Machines

To use this configuration file across multiple machines:

1. **Clone this repository** on each machine:
   ```bash
   git clone <your-repo-url> ~/.config/stats
   ```

2. **Locate your Stats preferences directory**:
   - The Stats preferences file is typically stored at:
     `~/Library/Preferences/eu.exelban.Stats.plist`

3. **Create a symbolic link** to sync the configuration:
   ```bash
   # Backup existing config (if any)
   mv ~/Library/Preferences/eu.exelban.Stats.plist ~/Library/Preferences/eu.exelban.Stats.plist.backup
   
   # Create symlink
   ln -s ~/.config/stats/Stats.plist ~/Library/Preferences/eu.exelban.Stats.plist
   ```

   Or simply copy the file:
   ```bash
   cp Stats.plist ~/Library/Preferences/eu.exelban.Stats.plist
   ```

4. **Restart Stats** for changes to take effect.

### Manual Installation

If you prefer to manually install the configuration:

1. Copy `Stats.plist` to `~/Library/Preferences/eu.exelban.Stats.plist`
2. Restart the Stats application

## Updating Configuration

When you make changes to your Stats preferences:

1. Open Stats and adjust settings as needed
2. Copy the updated preferences file back to this repository:
   ```bash
   cp ~/Library/Preferences/eu.exelban.Stats.plist ~/.config/stats/Stats.plist
   ```
3. Commit and push the changes:
   ```bash
   git add Stats.plist
   git commit -m "Update Stats configuration"
   git push
   ```

## License

This configuration file is for personal use. Stats itself is licensed under the MIT License.
