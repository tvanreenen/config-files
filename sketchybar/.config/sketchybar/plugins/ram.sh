#!/bin/sh


TOTAL_BYTES=$(sysctl -n hw.memsize 2>/dev/null)
VM_STAT=$(vm_stat 2>/dev/null)

# Stats-style used memory: include the compressed footprint, exclude caches.
# https://github.com/exelban/stats/blob/master/Modules/RAM/readers.swift
PERCENT=$(printf '%s\n' "$VM_STAT" | awk -F: -v total="$TOTAL_BYTES" '
  /page size of [0-9]+ bytes/ {
    size = $0
    sub(/^.*page size of /, "", size)
    sub(/ bytes.*$/, "", size)
  }
  $1 ~ /^(Pages active|Pages inactive|Pages speculative|Pages wired down|Pages occupied by compressor|Pages purgeable|File-backed pages)$/ {
    value = $2
    gsub(/[[:space:]]/, "", value)
    sub(/\.$/, "", value)
    if (value !~ /^[0-9]+$/) invalid = 1
    pages[$1] = value + 0
  }
  END {
    split("Pages active:Pages inactive:Pages speculative:Pages wired down:Pages occupied by compressor:Pages purgeable:File-backed pages", required, ":")
    for (i in required) if (!(required[i] in pages)) invalid = 1
    if (invalid || total !~ /^[0-9]+$/ || total <= 0 || size <= 0) exit
    used = (pages["Pages active"] + pages["Pages inactive"] + pages["Pages speculative"] + pages["Pages wired down"] + pages["Pages occupied by compressor"] - pages["Pages purgeable"] - pages["File-backed pages"]) * size
    if (used < 0 || used > total) exit
    printf "%.0f", used * 100 / total
  }
')

if [ -z "$PERCENT" ]; then
  sketchybar --set "$NAME" label="RAM N/A" label.color=0xff999999
  exit 0
fi

# This sysctl returns dispatch pressure flags, not internal kernel enum values.
PRESSURE=$(sysctl -n kern.memorystatus_vm_pressure_level 2>/dev/null)
case "$PRESSURE" in
  1) COLOR=0xffffffff ;; # Normal: keep the bar default.
  2) COLOR=0xffffc857 ;; # Warning.
  4) COLOR=0xffff5f57 ;; # Critical.
  *) COLOR=0xff999999 ;; # Pressure unavailable; retain the usage reading.
esac

sketchybar --set "$NAME" label="${PERCENT}%" label.color="$COLOR"
