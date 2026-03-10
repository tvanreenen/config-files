#!/bin/sh

# Load configuration
CONFIG_FILE="$HOME/.config/sketchybar/config.sh"
if [ -f "$CONFIG_FILE" ]; then
  . "$CONFIG_FILE"
fi

# Use GPS coordinates from config
LATITUDE="$WEATHER_LATITUDE"
LONGITUDE="$WEATHER_LONGITUDE"

URL="https://api.open-meteo.com/v1/forecast?latitude=${LATITUDE}&longitude=${LONGITUDE}&daily=sunrise,sunset&current=temperature_2m,relative_humidity_2m,wind_speed_10m,wind_direction_10m,wind_gusts_10m,apparent_temperature,pressure_msl&timezone=auto&forecast_days=1&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"

CACHE_FILE="/tmp/sketchybar_weather_cache"
CACHE_AGE=550
POPUP_ITEM="weather_summary_popup_0"
LLM_SUMMARY_PROMPT="In one short sentence under 75 characters, say how this weather likely feels or where it is heading. Interpret the conditions rather than listing numbers. Use the provided latitude and longitude as rough location context for what weather the user is generally adapted to. Return only the sentence with no quotes."

CURRENT_TIME=$(date +%s)
CURRENT_DATETIME_LOCAL=$(date '+%Y-%m-%d %H:%M %Z')

load_weather_json() {
  if [ -f "$CACHE_FILE" ]; then
    CACHE_TIME=$(head -1 "$CACHE_FILE")
    if [ $((CURRENT_TIME - CACHE_TIME)) -lt $CACHE_AGE ]; then
      json=$(tail -n +2 "$CACHE_FILE" | head -1)
      return 0
    fi
  fi

  json="$(curl -s --max-time 5 --connect-timeout 3 "$URL" 2>/dev/null)" || return 1
  {
    echo "$CURRENT_TIME"
    echo "$json"
  } > "$CACHE_FILE"
}

parse_weather_data() {
  eval $(echo "$json" | jq -r '
    .current.temperature_2m,
    .current.apparent_temperature,
    .current.relative_humidity_2m,
    .current.wind_speed_10m,
    .current.wind_direction_10m,
    .current.wind_gusts_10m,
    .current.pressure_msl,
    (.daily.sunrise[0] | split("T")[1]),
    (.daily.sunset[0] | split("T")[1])
  ' | awk '{
    if (NR==1) temp=$1
    if (NR==2) apparent=$1
    if (NR==3) rh=$1
    if (NR==4) wspd=$1
    if (NR==5) wdir=$1
    if (NR==6) wgust=$1
    if (NR==7) p_hpa=$1
    if (NR==8) sunrise=$1
    if (NR==9) sunset=$1
  }
  END {
    # Dew point calculation (Magnus formula)
    T=(temp-32)*5/9;
    if (rh>0) {
      a=17.27; b=237.7;
      g=log(rh/100.0)+(a*T)/(b+T);
      Td=(b*g)/(a-g);
      dewpoint=sprintf("%.0f", (Td*9/5+32));
    } else {
      dewpoint="nan";
    }

    # METAR standard: report gusts when peak exceeds average by 10+ knots (11.5 mph)
    # Using 12 mph threshold for simplicity
    if (wgust - wspd >= 12) {
      gust_str = sprintf("G%.0f", wgust)
    } else {
      gust_str = ""
    }

    printf "temp_f_formatted=\"%.0f\"; ", temp
    printf "apparent_temp_f_formatted=\"%.0f\"; ", apparent
    printf "dewpoint_f_formatted=\"%s\"; ", dewpoint
    printf "rh_formatted=\"%.0f\"; ", rh
    printf "wdir_formatted=\"%.0f\"; ", wdir
    printf "wspd_formatted=\"%.0f\"; ", wspd
    printf "wgust_formatted=\"%.0f\"; ", wgust
    printf "wgust_str=\"%s\"; ", gust_str
    printf "p_inhg=\"%.2f\"; ", p_hpa*0.0295299830714

    # Remove zero-padding from sunrise (07:23 -> 7:23)
    sunrise_hr = int(substr(sunrise, 1, 2))
    sunrise_min = substr(sunrise, 4, 2)

    printf "sunrise=\"%d:%s\"; ", sunrise_hr, sunrise_min
    printf "sunset=\"%s\"", sunset
  }')
}

update_weather_items() {
  sketchybar --set weather_sun label="${sunrise}↑ ${sunset}↓"
  sketchybar --set weather_temp label="${temp_f_formatted}°F"
  sketchybar --set weather_dewpoint label="${dewpoint_f_formatted}°F"
  sketchybar --set weather_wind label="${wdir_formatted}° ${wspd_formatted}${wgust_str}mph"
  sketchybar --set weather_pressure label="${p_inhg}\""
}

toggle_weather_summary() {
  command -v jq >/dev/null 2>&1 || return 0
  command -v llm >/dev/null 2>&1 || return 0

  if ! sketchybar --query "$POPUP_ITEM" >/dev/null 2>&1; then
    sketchybar --add item "$POPUP_ITEM" popup.weather_summary
    sketchybar --set "$POPUP_ITEM" \
      icon.drawing=off \
      label="Summarizing..." \
      label.max_chars=75 \
      width=400 \
      drawing=on
  fi

  popup_state=$(sketchybar --query weather_summary | jq -r '.popup.drawing')
  if [ "$popup_state" = "on" ]; then
    sketchybar --set weather_summary popup.drawing=off
    return 0
  fi

  sketchybar --set "$POPUP_ITEM" label="Summarizing..." drawing=on
  sketchybar --set weather_summary popup.drawing=on

  summary=$(
    printf '%s\n' \
      "current_datetime_local: $CURRENT_DATETIME_LOCAL" \
      "latitude: $LATITUDE" \
      "longitude: $LONGITUDE" \
      "temp_f: $temp_f_formatted" \
      "apparent_temp_f: $apparent_temp_f_formatted" \
      "dewpoint_f: $dewpoint_f_formatted" \
      "humidity_percent: $rh_formatted" \
      "wind_dir_deg: $wdir_formatted" \
      "wind_mph: $wspd_formatted" \
      "gust_mph: $wgust_formatted" \
      "pressure_inhg: $p_inhg" \
      "sunrise: $sunrise" \
      "sunset: $sunset" \
    | llm --no-stream -n -s "$LLM_SUMMARY_PROMPT" 2>/dev/null \
    | tr '\n' ' ' \
    | sed 's/[[:space:]][[:space:]]*/ /g; s/^ //; s/ $//'
  )

  [ -n "$summary" ] || summary="Summary unavailable."

  sketchybar --set "$POPUP_ITEM" label="$summary" drawing=on
}

load_weather_json || exit 1
[ -n "$json" ] || exit 1
parse_weather_data

if [ "${NAME:-}" = "weather_summary" ]; then
  [ "${SENDER:-}" = "mouse.clicked" ] || exit 0
  toggle_weather_summary
  exit 0
fi

update_weather_items
