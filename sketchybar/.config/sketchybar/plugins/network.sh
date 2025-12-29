#!/bin/sh

# Network plugin for SketchyBar
# Shows upload/download speeds in single line format

STATE_FILE="/tmp/sketchybar_network_state"

# Get network interface (WiFi or Ethernet)
INTERFACE=$(route get default 2>/dev/null | grep interface | awk '{print $2}')

if [ -z "$INTERFACE" ]; then
  # Fallback: check common interfaces
  if ifconfig en0 2>/dev/null | grep -q "status: active"; then
    INTERFACE="en0"
  elif ifconfig en1 2>/dev/null | grep -q "status: active"; then
    INTERFACE="en1"
  else
    sketchybar --set "$NAME" label="No connection"
    exit 0
  fi
fi

# Get current byte counts from netstat
CURRENT_RX=$(netstat -ib | grep "^$INTERFACE" | head -1 | awk '{print $7}')
CURRENT_TX=$(netstat -ib | grep "^$INTERFACE" | head -1 | awk '{print $10}')

if [ -z "$CURRENT_RX" ] || [ -z "$CURRENT_TX" ]; then
  DOWNLOAD="0.0K"
  UPLOAD="0.0K"
else
  # Read previous values from state file
  if [ -f "$STATE_FILE" ]; then
    PREV_TIME=$(head -1 "$STATE_FILE")
    PREV_RX=$(sed -n '2p' "$STATE_FILE")
    PREV_TX=$(sed -n '3p' "$STATE_FILE")
  else
    PREV_TIME=$(date +%s)
    PREV_RX=$CURRENT_RX
    PREV_TX=$CURRENT_TX
  fi
  
  # Calculate time difference (update every 2 seconds)
  CURRENT_TIME=$(date +%s)
  TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
  
  if [ "$TIME_DIFF" -lt 1 ]; then
    TIME_DIFF=1
  fi
  
  # Calculate speed (bytes per second)
  RX_SPEED=$(((CURRENT_RX - PREV_RX) / TIME_DIFF))
  TX_SPEED=$(((CURRENT_TX - PREV_TX) / TIME_DIFF))
  
  # Convert to human readable format (never below KB, single decimal)
  if [ "$RX_SPEED" -ge 1048576 ]; then
    DOWNLOAD=$(awk "BEGIN {printf \"%.1fM\", $RX_SPEED/1048576}")
  else
    DOWNLOAD=$(awk "BEGIN {printf \"%.1fK\", ($RX_SPEED + 1023)/1024}")
  fi
  
  if [ "$TX_SPEED" -ge 1048576 ]; then
    UPLOAD=$(awk "BEGIN {printf \"%.1fM\", $TX_SPEED/1048576}")
  else
    UPLOAD=$(awk "BEGIN {printf \"%.1fK\", ($TX_SPEED + 1023)/1024}")
  fi
  
  # Save current values for next run
  echo "$CURRENT_TIME" > "$STATE_FILE"
  echo "$CURRENT_RX" >> "$STATE_FILE"
  echo "$CURRENT_TX" >> "$STATE_FILE"
fi

sketchybar --set "$NAME" label="${UPLOAD} ${DOWNLOAD}"
