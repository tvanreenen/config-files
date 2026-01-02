#!/bin/sh

STATE_FILE="/tmp/sketchybar_gpu_python"
TMP_PLIST="/tmp/sketchybar_gpu.plist"

if [ -f "$STATE_FILE" ]; then
  HAS_PYTHON3=$(cat "$STATE_FILE")
else
  if command -v python3 >/dev/null 2>&1; then
    HAS_PYTHON3="yes"
    echo "yes" > "$STATE_FILE"
  else
    HAS_PYTHON3="no"
    echo "no" > "$STATE_FILE"
  fi
fi

GPU_USAGE=""

if [ "$HAS_PYTHON3" = "yes" ]; then
  ioreg -r -c IOAccelerator -a 2>/dev/null > "$TMP_PLIST"
  
  if [ -s "$TMP_PLIST" ]; then
    # Use Python/plistlib because plutil can't convert plists with <data> elements to JSON
    GPU_USAGE=$(python3 - <<PY
import plistlib
with open("$TMP_PLIST", "rb") as f:
    data = plistlib.load(f)
items = data if isinstance(data, list) else [data]
keys = ["Device Utilization %", "GPU Activity(%)", "GPU Activity (%)"]
for it in items:
    ps = it.get("PerformanceStatistics", {})
    if ps:
        for k in keys:
            if k in ps:
                print(ps[k])
                exit(0)
print("")
PY
)
  fi
fi

if [ -n "$GPU_USAGE" ] && [ "$GPU_USAGE" != "" ]; then
  sketchybar --set "$NAME" label="${GPU_USAGE}%"
else
  sketchybar --set "$NAME" label="--"
fi
