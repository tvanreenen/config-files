# Stats Configuration

Personal configuration file for [Stats](https://github.com/exelban/stats) - a macOS system monitor for the menu bar.

## Usage

To use this configuration file across multiple machines:

1. **Locate your Stats preferences directory**:
   - The Stats preferences file is stored at:
     `~/Library/Preferences/eu.exelban.Stats.plist`

2. **Create a symbolic link** to sync the configuration:
   ```bash
   # Backup existing config (if any)
   mv ~/Library/Preferences/eu.exelban.Stats.plist ~/Library/Preferences/eu.exelban.Stats.plist.backup
   
   # Create symlink (adjust the source path to match your repository location)
   ln -s ~/Code/config-files/stats/Stats.plist ~/Library/Preferences/eu.exelban.Stats.plist
   ```

   Or simply copy the file:
   ```bash
   # Copy the config file (adjust the source path to match your repository location)
   cp ~/Code/config-files/stats/Stats.plist ~/Library/Preferences/eu.exelban.Stats.plist
   ```

3. **Restart Stats** for changes to take effect.
