#!/bin/sh

STATE_FILE="/tmp/sketchybar_cpu_cores"

# Cache CPU core count (never changes)
if [ -f "$STATE_FILE" ]; then
  CPU_CORES=$(cat "$STATE_FILE")
else
  CPU_CORES=$(sysctl -n hw.ncpu 2>/dev/null || echo "1")
  echo "$CPU_CORES" > "$STATE_FILE"
fi

CPU_USAGE=$(top -l 1 | awk -v cores="$CPU_CORES" '/CPU usage/ {
  user = $3
  sys = $5
  gsub(/%/, "", user)
  gsub(/%/, "", sys)
  # Calculate average CPU usage per core (matches Activity Monitor)
  usage = (user + sys) / cores
  if (usage < 0) usage = 0
  if (usage > 100) usage = 100
  printf "%.0f", usage
  exit
}')

if [ -z "$CPU_USAGE" ]; then
  sketchybar --set "$NAME" label="--"
else
  sketchybar --set "$NAME" label="${CPU_USAGE}%"
fi
