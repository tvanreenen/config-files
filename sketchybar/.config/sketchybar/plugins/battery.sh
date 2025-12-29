#!/bin/sh

# Battery plugin for SketchyBar

BATT_INFO=$(pmset -g batt)

# Check if battery exists (desktop Macs don't have batteries)
if echo "$BATT_INFO" | grep -q "InternalBattery"; then
  # Get battery percentage
  PERCENTAGE=$(echo "$BATT_INFO" | grep -Eo "\d+%" | cut -d% -f1)
  
  # Get charging status
  CHARGING=$(echo "$BATT_INFO" | grep -i "AC Power")
  
  # Get remaining time (format: H:MM)
  REMAINING=$(echo "$BATT_INFO" | grep -Eo "\d+:\d+ remaining" | head -1 | sed 's/ remaining//')
  
  if [ -z "$REMAINING" ]; then
    REMAINING="--:--"
  fi
  
  sketchybar --set "$NAME" label="${PERCENTAGE}% ${REMAINING}"
else
  # No battery (desktop Mac)
  sketchybar --set "$NAME" label="AC"
fi

