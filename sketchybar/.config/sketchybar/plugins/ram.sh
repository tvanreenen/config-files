#!/bin/sh


STATE_FILE="/tmp/sketchybar_ram_total"

if [ -f "$STATE_FILE" ]; then
  TOTAL_PHYSICAL_MB=$(cat "$STATE_FILE")
else
  TOTAL_PHYSICAL_BYTES=$(sysctl -n hw.memsize 2>/dev/null)
  if [ -z "$TOTAL_PHYSICAL_BYTES" ]; then
    sketchybar --set "$NAME" label="RAM N/A"
    exit 0
  fi
  TOTAL_PHYSICAL_MB=$((TOTAL_PHYSICAL_BYTES / 1024 / 1024))
  echo "$TOTAL_PHYSICAL_MB" > "$STATE_FILE"
fi

MEM_DATA=$(top -l 1 | awk '/PhysMem/ {
  compressed = $6
  gsub(/M/, "", compressed)
  gsub(/,/, "", compressed)
  print compressed
  exit
}')

VM_STAT=$(vm_stat)

if [ -z "$MEM_DATA" ] || [ -z "$VM_STAT" ]; then
  sketchybar --set "$NAME" label="RAM N/A"
  exit 0
fi

USED_MB=$(echo "$VM_STAT" | awk -v compressed="$MEM_DATA" '
  /Pages active/ {active = $NF; gsub(/\./, "", active)}
  /Pages wired/ {wired = $NF; gsub(/\./, "", wired)}
  END {
    # Convert pages to MB (16KB per page) and add compressed
    active_mb = active * 16 / 1024
    wired_mb = wired * 16 / 1024
    used = active_mb + wired_mb + compressed
    printf "%.0f", used
  }
')

if [ -z "$USED_MB" ] || [ "$TOTAL_PHYSICAL_MB" = "0" ]; then
  sketchybar --set "$NAME" label="RAM N/A"
  exit 0
fi

PERCENT=$((USED_MB * 100 / TOTAL_PHYSICAL_MB))

sketchybar --set "$NAME" label="${PERCENT}%"
