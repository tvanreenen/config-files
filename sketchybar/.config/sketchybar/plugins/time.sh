#!/bin/sh

# Format: DATE|WEEK|DAY_ABBR|TIME|OFFSET
LABEL=$(date '+%Y-%m-%d|%V|%a|%H:%M:%S|%z' | awk -F'|' '{
  week = int($2)
  printf "%s W%d %s %s %s", $1, week, substr($3, 1, 1), $4, $5
}')

sketchybar --set "$NAME" label="$LABEL"
