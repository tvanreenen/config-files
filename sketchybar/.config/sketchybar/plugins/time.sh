#!/bin/sh

# Format: DATE|WEEK|DAY_ABBR|TIME|OFFSET
LABEL=$(date '+%Y-%m-%d|%V|%a|%H:%M:%S|%z' | awk -F'|' '{
  week = int($2)
  tz = sprintf("%+.1g", (substr($5,1,1)=="-"?-1:1) * (substr($5,2,2) + substr($5,4,2)/60))
  printf "%s W%d %s %s %s", $1, week, substr($3, 1, 1), $4, tz
}')

sketchybar --set "$NAME" label="$LABEL"
