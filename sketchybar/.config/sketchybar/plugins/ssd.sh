#!/bin/sh

# SSD/Disk usage plugin for SketchyBar
# Calculates usage based on physical APFS container (matches Stats app)

# Find the APFS container for root filesystem
ROOT_DEVICE=$(df / | tail -1 | awk '{print $1}')
CONTAINER=$(echo "$ROOT_DEVICE" | sed 's/.*disk\([0-9]*\).*/disk\1/')

# Get physical store info from diskutil
APFS_INFO=$(diskutil apfs list "$CONTAINER" 2>/dev/null)

if [ -z "$APFS_INFO" ]; then
  sketchybar --set "$NAME" label="SSD N/A"
  exit 0
fi

# Extract physical store size and sum all capacity consumed
SIZE_LINE=$(echo "$APFS_INFO" | grep -A 2 "Physical Store" | grep "Size:" | head -1)
SIZE_BYTES=$(echo "$SIZE_LINE" | awk -F: '{print $2}' | awk '{print $1}' | sed 's/[^0-9]//g')

# Sum all "Capacity Consumed" values for the physical store
CONSUMED_BYTES=$(echo "$APFS_INFO" | awk '/Physical Store/,0' | grep "Capacity Consumed:" | awk -F: '{print $2}' | awk '{gsub(/[^0-9]/, "", $1); if ($1 != "") sum+=$1} END {print sum+0}')

if [ -n "$SIZE_BYTES" ] && [ "$SIZE_BYTES" -gt 0 ] && [ -n "$CONSUMED_BYTES" ]; then
  USAGE=$((CONSUMED_BYTES * 100 / SIZE_BYTES))
  sketchybar --set "$NAME" label="SSD ${USAGE}%"
else
  sketchybar --set "$NAME" label="SSD N/A"
fi
