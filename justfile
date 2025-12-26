default:
	@just --list --unsorted
	
# Copy Desktop stats configuration
stats-desktop:
    cp ~/Code/config-files/stats/Stats-Desktop.plist ~/Library/Preferences/eu.exelban.Stats.plist

# Copy Laptop stats configuration
stats-laptop:
    cp ~/Code/config-files/stats/Stats-Laptop.plist ~/Library/Preferences/eu.exelban.Stats.plist
