# AeroSpace Configuration

Personal configuration file for [AeroSpace](https://github.com/nikitabobko/AeroSpace) - an i3-like tiling window manager for macOS.

## Usage

To use this configuration file across multiple machines:

1. **Locate AeroSpace's config location**:
   - The configuration file should be placed at:
     `~/.aerospace.toml`

2. **Create a symbolic link** to sync the configuration:

   ```bash
   # Backup existing config (if any)
   mv ~/.aerospace.toml ~/.aerospace.toml.backup
   
   # Create symlink (adjust the source path to match your repository location)
   ln -s ~/Code/config-files/AeroSpace/.aerospace.toml ~/.aerospace.toml
   ```

   Or simply copy the file:

   ```bash
   # Copy the config file (adjust the source path to match your repository location)
   cp ~/Code/config-files/AeroSpace/.aerospace.toml ~/.aerospace.toml
   ```

3. **Reload AeroSpace configuration**:
   - Press `alt-shift-semicolon` to enter service mode, then `esc` to reload
   - Or restart AeroSpace for changes to take effect

## Configuration

This configuration is set up for a dual-monitor setup with 10 workspaces:

- Workspaces 1-5 assigned to the left monitor (secondary)
- Workspaces 6-0 assigned to the right monitor (main/primary)
- All workspaces are persistent
