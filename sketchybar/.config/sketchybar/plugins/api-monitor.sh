#!/bin/sh

# API Monitoring plugin for SketchyBar
# Checks API endpoints from config.sh and displays status

# Load configuration
CONFIG_FILE="$HOME/.config/sketchybar/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
  sketchybar --set "$NAME" label="-"
  exit 0
fi

. "$CONFIG_FILE"

# Function to check if an API is up
check_api() {
  local url=$1
  local status_code
  
  # Use curl with 10-second timeout, get HTTP status code
  status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null)
  
  # Check if status code is 2xx or 3xx (success)
  if [ -n "$status_code" ] && [ "$status_code" -ge 200 ] && [ "$status_code" -lt 400 ]; then
    return 0  # API is up
  else
    return 1  # API is down
  fi
}

# Check all APIs from array
all_up=true

# Check if API_MONITOR_URLS array is defined and not empty
if [ -z "${API_MONITOR_URLS+x}" ] || [ ${#API_MONITOR_URLS[@]} -eq 0 ]; then
  sketchybar --set "$NAME" label="⚠️"
  exit 0
fi

# Loop through array and check each URL
for url in "${API_MONITOR_URLS[@]}"; do
  if ! check_api "$url"; then
    all_up=false
    break
  fi
done

# Update SketchyBar label based on status
if [ "$all_up" = true ]; then
  sketchybar --set "$NAME" label="✔"
else
  sketchybar --set "$NAME" label="⚠️"
fi
