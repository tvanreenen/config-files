#!/bin/bash

# API Monitoring plugin for SketchyBar
# Checks API endpoints from config.sh and displays status in a popup menu

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

# Function to ensure popup item exists and update its status
update_popup_item() {
  local popup_item=$1
  local service_name=$2
  local is_up=$3
  
  # Create popup item if it doesn't exist
  if ! sketchybar --query "$popup_item" >/dev/null 2>&1; then
    sketchybar --add item "$popup_item" popup.api_monitor
    sketchybar --set "$popup_item" \
      icon="⏺" \
      label="${service_name}"
  fi
  
  # Update status with appropriate color
  local color=$(get_status_color "$is_up")
  
  sketchybar --set "$popup_item" \
    icon="⏺" \
    icon.color=$color \
    label="${service_name}" \
    drawing=on
}

# Function to get status color (green for up, red for down)
get_status_color() {
  local is_up=$1
  if [ "$is_up" = true ]; then
    echo "0xFF00FF00"  # Green
  else
    echo "0xFFFF0000"  # Red
  fi
}

# Check if API_MONITOR_CONFIG is defined and not empty
if [ -z "${API_MONITOR_CONFIG+x}" ] || [ -z "$API_MONITOR_CONFIG" ]; then
  sketchybar --set "$NAME" label="⚠️"
  exit 0
fi

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="⚠️"
  exit 0
fi

# Parse JSON and iterate over key-value pairs
all_up=true
idx=0

# Use process substitution to avoid subshell issues (requires bash)
while IFS='|' read -r service_name url; do
  if [ -z "$service_name" ] || [ -z "$url" ]; then
    continue
  fi
  
  popup_item="api_monitor_popup_${idx}"
  
  # Check individual API status
  if check_api "$url"; then
    update_popup_item "$popup_item" "$service_name" true
  else
    update_popup_item "$popup_item" "$service_name" false
    all_up=false
  fi
  
  idx=$((idx + 1))
done < <(echo "$API_MONITOR_CONFIG" | jq -r 'to_entries[] | "\(.key)|\(.value)"')

# If no items were processed, set a default status
if [ $idx -eq 0 ]; then
  sketchybar --set "$NAME" label="⚠️"
  exit 0
fi

# Update main item with aggregate status
status_color=$(get_status_color "$all_up")
sketchybar --set "$NAME" \
  label="⏺" \
  label.color=$status_color \
  label.drawing=on
