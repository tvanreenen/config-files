#!/bin/sh

# Time plugin for SketchyBar
# Format: Single letter day, HH:MM:SS UTC±offset, yyyy-mm-dd Www

# Get current date and time components
DATE=$(date '+%Y-%m-%d')
WEEK=$(date '+%V' | awk '{printf "%02d", $1}')  # Zero-padded week
DAY_LETTER=$(date '+%A' | cut -c1)  # First letter of day name
TIME=$(date '+%H:%M:%S')
UTC_OFFSET=$(date '+%z')

sketchybar --set "$NAME" label="${DATE} W${WEEK} ${DAY_LETTER} ${TIME} ${UTC_OFFSET}"

