#!/bin/sh

# Use the second sample for a two-second interval, not top's startup sample.
CPU_USAGE=$(top -l 2 -s 2 -n 0 | awk '/CPU usage/ && ++samples == 2 {
  user = $3
  sys = $5
  gsub(/%/, "", user)
  gsub(/%/, "", sys)
  # top already reports CPU usage normalized across all cores.
  usage = user + sys
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
