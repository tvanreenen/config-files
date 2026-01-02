#!/bin/sh

# AeroSpace workspace indicator plugin for SketchyBar
# Single monitor: shows just the workspace number
# Multiple monitors: shows all workspaces separated by pipe

if ! command -v aerospace >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="--"
  exit 0
fi

MONITOR_COUNT=$(aerospace list-monitors 2>/dev/null | wc -l | tr -d ' ')

# Single monitor: just show the focused workspace
if [ "$MONITOR_COUNT" -eq 1 ]; then
  WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null | head -1 | awk '{print $1}')
  if [ -n "$WORKSPACE" ]; then
    sketchybar --set "$NAME" label="$WORKSPACE"
  else
    sketchybar --set "$NAME" label="--"
  fi
  exit 0
fi

# Multiple monitors: show all workspaces
WORKSPACES=""

for monitor in $(aerospace list-monitors 2>/dev/null | awk '{print $1}'); do
  [ -z "$monitor" ] && continue
  
  WORKSPACE=$(aerospace list-workspaces --visible --monitor "$monitor" 2>/dev/null | head -1 | awk '{print $1}')
  [ -z "$WORKSPACE" ] && continue
  
  [ -n "$WORKSPACES" ] && WORKSPACES="${WORKSPACES} | "
  WORKSPACES="${WORKSPACES}${WORKSPACE}"
done

if [ -n "$WORKSPACES" ]; then
  sketchybar --set "$NAME" label="$WORKSPACES"
else
  sketchybar --set "$NAME" label="--"
fi
