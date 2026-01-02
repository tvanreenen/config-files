#!/bin/sh

# GPU plugin for SketchyBar
# Uses ioreg to query IOKit directly for GPU utilization (fast, no sudo required)
# Note: plutil can't convert plists with <data> elements to JSON, so we use plistlib directly

GPU_USAGE=""

# Query IOKit for GPU accelerator performance statistics
# This uses ioreg to access IOAccelerator entries and extract GPU utilization
if command -v python3 >/dev/null 2>&1; then
  TMP_PLIST=$(mktemp /tmp/sketchybar_gpu.XXXXXX.plist)
  ioreg -r -c IOAccelerator -a 2>/dev/null > "$TMP_PLIST"
  
  if [ -s "$TMP_PLIST" ]; then
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
  
  rm -f "$TMP_PLIST"
fi

# Format output: show usage percentage only
if [ -n "$GPU_USAGE" ] && [ "$GPU_USAGE" != "" ]; then
  sketchybar --set "$NAME" label="${GPU_USAGE}%"
else
  sketchybar --set "$NAME" label="--"
fi
