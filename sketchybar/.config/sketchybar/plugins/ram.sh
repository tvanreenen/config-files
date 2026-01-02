#!/bin/sh

# RAM usage plugin for SketchyBar
# Calculates usage as (Active + Wired + Compressed) / total physical RAM
# This matches Activity Monitor's "Memory Used" which excludes cached files
# (cached files can be freed immediately, so they're not really "used")

# Get memory info
MEM_INFO=$(top -l 1 | grep "PhysMem")
VM_STAT=$(vm_stat)

if [ -z "$MEM_INFO" ] || [ -z "$VM_STAT" ]; then
  sketchybar --set "$NAME" label="RAM N/A"
  exit 0
fi

# Parse compressed memory from top: "PhysMem: 7510M used (1907M wired, 2577M compressor), 74M unused."
COMPRESSED=$(echo "$MEM_INFO" | awk '{print $6}' | sed 's/M//' | sed 's/,//')

# Get active and wired pages from vm_stat (pages are 16KB)
ACTIVE_PAGES=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $NF}' | sed 's/\.//')
WIRED_PAGES=$(echo "$VM_STAT" | grep "Pages wired" | awk '{print $NF}' | sed 's/\.//')

# Convert pages to MB (16KB per page)
ACTIVE_MB=$((ACTIVE_PAGES * 16 / 1024))
WIRED_MB=$((WIRED_PAGES * 16 / 1024))

# Calculate used memory: Active + Wired + Compressed (excludes cached)
USED_MB=$((ACTIVE_MB + WIRED_MB + COMPRESSED))

# Get total physical RAM
TOTAL_PHYSICAL_BYTES=$(sysctl -n hw.memsize)
TOTAL_PHYSICAL_MB=$((TOTAL_PHYSICAL_BYTES / 1024 / 1024))

if [ -z "$TOTAL_PHYSICAL_MB" ] || [ "$TOTAL_PHYSICAL_MB" = "0" ]; then
  sketchybar --set "$NAME" label="RAM N/A"
  exit 0
fi

# Calculate percentage
PERCENT=$((USED_MB * 100 / TOTAL_PHYSICAL_MB))

sketchybar --set "$NAME" label="${PERCENT}%"
