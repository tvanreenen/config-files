#!/bin/sh

# Front app plugin for SketchyBar
# Shows the name of the currently focused application

# The front_app_switched event sends the app name in $INFO
if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
fi

