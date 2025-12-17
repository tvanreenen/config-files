# Stats Configuration

Personal configuration file for [Stats](https://github.com/exelban/stats) - a macOS system monitor for the menu bar.

## Usage

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
