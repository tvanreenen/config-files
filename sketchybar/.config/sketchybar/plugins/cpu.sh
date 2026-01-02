#!/bin/sh

# CPU usage plugin for SketchyBar
# Uses top/iostat for fast response (macmon is too slow for 2-second updates)

# Get CPU usage from top command
CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')

if [ -z "$CPU_USAGE" ]; then
  # Alternative method using iostat if available
  if command -v iostat >/dev/null 2>&1; then
    CPU_USAGE=$(iostat -w 1 -c 2 | tail -1 | awk '{printf "%.0f", 100-$6}')
  else
    sketchybar --set "$NAME" label="CPU N/A"
    exit 0
  fi
fi

# Round to integer
CPU_USAGE=$(printf "%.0f" "$CPU_USAGE" 2>/dev/null || echo "0")

sketchybar --set "$NAME" label="${CPU_USAGE}%"

