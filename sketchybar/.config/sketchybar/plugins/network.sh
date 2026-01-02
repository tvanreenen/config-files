#!/bin/sh

STATE_FILE="/tmp/sketchybar_network_state"
INTERFACE_FILE="/tmp/sketchybar_network_interface"

CURRENT_TIME=$(date +%s)

INTERFACE=""
if [ -f "$INTERFACE_FILE" ]; then
  INTERFACE_CACHE_TIME=$(head -1 "$INTERFACE_FILE")
  if [ $((CURRENT_TIME - INTERFACE_CACHE_TIME)) -lt 60 ]; then
    INTERFACE=$(sed -n '2p' "$INTERFACE_FILE")
  fi
fi

if [ -z "$INTERFACE" ]; then
  INTERFACE=$(route get default 2>/dev/null | awk '/interface/ {print $2}')
  
  if [ -z "$INTERFACE" ]; then
    if ifconfig en0 2>/dev/null | grep -q "status: active"; then
      INTERFACE="en0"
    elif ifconfig en1 2>/dev/null | grep -q "status: active"; then
      INTERFACE="en1"
    else
      sketchybar --set "$NAME" label="--"
      exit 0
    fi
  fi
  
  echo "$CURRENT_TIME" > "$INTERFACE_FILE"
  echo "$INTERFACE" >> "$INTERFACE_FILE"
fi

NETSTAT_DATA=$(netstat -ib | awk -v iface="$INTERFACE" '$1 == iface {print $7, $10; exit}')

if [ -z "$NETSTAT_DATA" ]; then
  LABEL="0.0K↑ 0.0K↓"
else
  CURRENT_RX=$(echo "$NETSTAT_DATA" | awk '{print $1}')
  CURRENT_TX=$(echo "$NETSTAT_DATA" | awk '{print $2}')
  
  if [ -z "$CURRENT_RX" ] || [ -z "$CURRENT_TX" ]; then
    LABEL="0.0K↑ 0.0K↓"
  else
    if [ -f "$STATE_FILE" ]; then
      PREV_TIME=$(head -1 "$STATE_FILE")
      PREV_RX=$(sed -n '2p' "$STATE_FILE")
      PREV_TX=$(sed -n '3p' "$STATE_FILE")
    else
      PREV_TIME=$CURRENT_TIME
      PREV_RX=$CURRENT_RX
      PREV_TX=$CURRENT_TX
    fi
    
    TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
    
    if [ "$TIME_DIFF" -lt 1 ]; then
      TIME_DIFF=1
    fi
    
    RX_SPEED=$(((CURRENT_RX - PREV_RX) / TIME_DIFF))
    TX_SPEED=$(((CURRENT_TX - PREV_TX) / TIME_DIFF))
    
    LABEL=$(awk -v rx="$RX_SPEED" -v tx="$TX_SPEED" 'BEGIN {
      if (tx >= 1048576) {
        upload = sprintf("%.1fM", tx/1048576)
      } else {
        upload = sprintf("%.1fK", (tx + 1023)/1024)
      }
      if (rx >= 1048576) {
        download = sprintf("%.1fM", rx/1048576)
      } else {
        download = sprintf("%.1fK", (rx + 1023)/1024)
      }
      print upload "↑ " download "↓"
    }')
    
    echo "$CURRENT_TIME" > "$STATE_FILE"
    echo "$CURRENT_RX" >> "$STATE_FILE"
    echo "$CURRENT_TX" >> "$STATE_FILE"
  fi
fi

sketchybar --set "$NAME" label="$LABEL"
