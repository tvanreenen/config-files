#!/bin/bash

# API Monitoring plugin for SketchyBar
# Shows Live monitor results or probes the URLs configured in config.sh.

# Load configuration
CONFIG_FILE="$HOME/.config/sketchybar/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
  sketchybar --set "$NAME" label="-"
  exit 0
fi

# shellcheck source=/dev/null
. "$CONFIG_FILE"

DOWN_FLAG="${TMPDIR:-/tmp}/sketchybar-api-monitor-down"

notify_on_outage() {
  case "$1" in
    up) rm -f "$DOWN_FLAG" ;;
    down)
      if [ ! -f "$DOWN_FLAG" ]; then
        osascript -e 'display notification "One or more API checks failed" with title "API Monitor"' >/dev/null 2>&1
        : > "$DOWN_FLAG"
      fi
      ;;
  esac
}

# Function to check if an API is up
check_api() {
  local url=$1
  local status_code
  
  # Use curl with 10-second timeout, get HTTP status code
  status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null)
  
  # Check if status code is 2xx or 3xx (success)
  if [ -n "$status_code" ] && [ "$status_code" -ge 200 ] && [ "$status_code" -lt 400 ]; then
    return 0  # API is up
  else
    return 1  # API is down
  fi
}

# Function to ensure popup item exists and update its status
update_popup_item() {
  local popup_item=$1
  local service_name=$2
  local status=$3
  
  # Create popup item if it doesn't exist
  if ! sketchybar --query "$popup_item" >/dev/null 2>&1; then
    sketchybar --add item "$popup_item" popup.api_monitor
  fi
  
  sketchybar --set "$popup_item" \
    icon="⏺" \
    icon.color="$(get_status_color "$status")" \
    label="${service_name}" \
    drawing=on
}

get_status_color() {
  case "$1" in
    up) echo "0xFF00FF00" ;;
    down) echo "0xFFFF0000" ;;
    maintenance) echo "0xFF66AAFF" ;;
    *) echo "0xFF999999" ;;
  esac
}

remove_extra_popup_items() {
  local idx=$1
  while [[ -n $(sketchybar --query "api_monitor_popup_${idx}" 2>/dev/null) ]]; do
    sketchybar --remove "api_monitor_popup_${idx}"
    idx=$((idx + 1))
  done
}

show_live_error() {
  update_popup_item api_monitor_popup_0 "$1" unknown
  remove_extra_popup_items 1
  sketchybar --set "$NAME" label="⚠️" label.color="$(get_status_color unknown)"
}

update_live_monitors() {
  local id idx status service_name result response_dir
  local up=0 down=0 unknown=0 maintenance=0
  local color=0xFFFFFFFF
  local -a ids requests
  read -r -a ids <<< "${LIVE_MONITOR_IDS:-}"

  if [ -z "${LIVE_STATUS:-}" ] || [ "${#ids[@]}" -eq 0 ]; then
    show_live_error "Set LIVE_STATUS and LIVE_MONITOR_IDS in config.sh"
    return
  fi

  if [ "${#ids[@]}" -gt 100 ]; then
    show_live_error "Configure up to 100 Live monitor IDs"
    return
  fi

  for id in "${ids[@]}"; do
    if [[ ! "$id" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$ ]]; then
      show_live_error "LIVE_MONITOR_IDS requires lowercase monitor UUIDs"
      return
    fi
  done

  if ! response_dir=$(mktemp -d "${TMPDIR:-/tmp}/sketchybar-live.XXXXXX"); then
    show_live_error "Could not read Live monitor status"
    return
  fi

  requests=()
  for idx in "${!ids[@]}"; do
    requests+=(--output "$response_dir/$idx"
      "https://live.tvr.works/v1/monitors/${ids[idx]}?bucketMinutes=1&limit=30")
  done

  # Give all requests time to finish within SketchyBar's 60-second script limit.
  # Each failed transfer leaves its own row without a result.
  printf 'Authorization: Bearer %s\n' "$LIVE_STATUS" |
    curl -q --silent --fail --remove-on-error --max-time 8 --parallel --parallel-max 20 \
      --header @- "${requests[@]}"

  for idx in "${!ids[@]}"; do
    id=${ids[idx]}
    status=unknown
    service_name="Live monitor (${id:0:8})"
    if [ -s "$response_dir/$idx" ] && result=$(jq -er --arg id "$id" '
      select(.monitor.id == $id and (.monitor.name | type == "string"))
      | .monitor
      | (.buckets | map(select(.passed > 0 or .failed > 0 or .maintenance > 0)) | last) as $latest
      | (if $latest == null then "unknown"
         elif $latest.failed > 0 and $latest.passed == 0 and $latest.maintenance == 0 then "down"
         elif $latest.passed > 0 and $latest.failed == 0 and $latest.maintenance == 0 then "up"
         elif $latest.maintenance > 0 and $latest.passed == 0 and $latest.failed == 0 then "maintenance"
         else "unknown" end)
        + "\t" + (.name | gsub("[[:cntrl:]]"; " "))
    ' "$response_dir/$idx" 2>/dev/null); then
      IFS=$'\t' read -r status service_name <<< "$result"
    fi

    case "$status" in
      up) up=$((up + 1)) ;;
      down) down=$((down + 1)) ;;
      maintenance) maintenance=$((maintenance + 1)) ;;
      *) unknown=$((unknown + 1)) ;;
    esac
    update_popup_item "api_monitor_popup_${idx}" "$service_name" "$status"
  done
  rm -r "$response_dir"
  remove_extra_popup_items "${#ids[@]}"

  if [ "$down" -gt 0 ]; then
    notify_on_outage down
    color=$(get_status_color down)
  elif [ "$unknown" -gt 0 ]; then
    color=$(get_status_color unknown)
  else
    notify_on_outage up
    if [ "$maintenance" -gt 0 ]; then
      color=$(get_status_color maintenance)
    fi
  fi
  sketchybar --set "$NAME" label="$up/${#ids[@]}" label.color="$color" label.drawing=on
}

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="⚠️"
  exit 0
fi

if [ -n "${LIVE_MONITOR_IDS:-}" ] || { [ -n "${LIVE_STATUS:-}" ] && [ -z "${API_MONITOR_CONFIG:-}" ]; }; then
  update_live_monitors
  exit 0
fi

if [ -z "${API_MONITOR_CONFIG:-}" ]; then
  sketchybar --set "$NAME" label="⚠️"
  exit 0
fi

# Parse JSON and iterate over key-value pairs
all_up=true
idx=0

# Use process substitution to avoid subshell issues (requires bash)
while IFS='|' read -r service_name url; do
  if [ -z "$service_name" ] || [ -z "$url" ]; then
    continue
  fi
  
  popup_item="api_monitor_popup_${idx}"
  
  # Check individual API status
  if check_api "$url"; then
    update_popup_item "$popup_item" "$service_name" up
  else
    update_popup_item "$popup_item" "$service_name" down
    all_up=false
  fi
  
  idx=$((idx + 1))
done < <(echo "$API_MONITOR_CONFIG" | jq -r 'to_entries[] | "\(.key)|\(.value)"')

remove_extra_popup_items "$idx"

# If no items were processed, set a default status
if [ $idx -eq 0 ]; then
  sketchybar --set "$NAME" label="⚠️"
  exit 0
fi

# Update main item with aggregate status
if [ "$all_up" = true ]; then
  notify_on_outage up
  status_color="0xFFFFFFFF"
else
  notify_on_outage down
  status_color=$(get_status_color down)
fi
sketchybar --set "$NAME" \
  label="$(date +%H:%M)" \
  label.color="$status_color" \
  label.drawing=on
