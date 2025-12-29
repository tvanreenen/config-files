#!/bin/sh

# AeroSpace workspace indicator plugin for SketchyBar
# Shows workspace IDs for each monitor, separated by pipe, with * on focused monitor

if ! command -v aerospace >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="--"
  exit 0
fi

# Get the focused monitor
FOCUSED_MONITOR=$(aerospace list-monitors --focused 2>/dev/null | head -1 | awk '{print $1}')

# Get all monitors and their workspaces
WORKSPACES=""
FIRST=true

# Query each monitor for its workspace
for monitor in $(aerospace list-monitors 2>/dev/null | awk '{print $1}'); do
  if [ -z "$monitor" ]; then
    continue
  fi
  
  # Get workspace for this monitor
  WORKSPACE=$(aerospace list-workspaces --monitor "$monitor" 2>/dev/null | head -1 | awk '{print $1}')
  
  if [ -n "$WORKSPACE" ]; then
    if [ "$FIRST" = true ]; then
      FIRST=false
    else
      WORKSPACES="${WORKSPACES} | "
    fi
    
    # Add asterisk if this is the focused monitor
    if [ "$monitor" = "$FOCUSED_MONITOR" ]; then
      WORKSPACES="${WORKSPACES}${WORKSPACE}*"
    else
      WORKSPACES="${WORKSPACES}${WORKSPACE}"
    fi
  fi
done

if [ -n "$WORKSPACES" ]; then
  sketchybar --set "$NAME" label="$WORKSPACES"
else
  sketchybar --set "$NAME" label="--"
fi

