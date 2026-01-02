#!/bin/sh

URL="https://api.open-meteo.com/v1/forecast?latitude=42.87&longitude=-85.44&daily=sunrise,sunset&current=temperature_2m,relative_humidity_2m,wind_speed_10m,wind_direction_10m,wind_gusts_10m,apparent_temperature,pressure_msl&timezone=auto&forecast_days=1&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"

CACHE_FILE="/tmp/sketchybar_weather_cache"
CACHE_AGE=550

CURRENT_TIME=$(date +%s)

if [ -f "$CACHE_FILE" ]; then
  CACHE_TIME=$(head -1 "$CACHE_FILE")
  if [ $((CURRENT_TIME - CACHE_TIME)) -lt $CACHE_AGE ]; then
    json=$(tail -n +2 "$CACHE_FILE")
  else
    json="$(curl -s "$URL")" || exit 1
    echo "$CURRENT_TIME" > "$CACHE_FILE"
    echo "$json" >> "$CACHE_FILE"
  fi
else
  json="$(curl -s "$URL")" || exit 1
  echo "$CURRENT_TIME" > "$CACHE_FILE"
  echo "$json" >> "$CACHE_FILE"
fi

# Extract all fields and format in single jq/awk pass
eval $(echo "$json" | jq -r '
  .current.temperature_2m,
  .current.relative_humidity_2m,
  .current.wind_speed_10m,
  .current.wind_direction_10m,
  .current.wind_gusts_10m,
  .current.pressure_msl,
  (.daily.sunrise[0] | split("T")[1]),
  (.daily.sunset[0] | split("T")[1])
' | awk '{
  if (NR==1) temp=$1
  if (NR==2) rh=$1
  if (NR==3) wspd=$1
  if (NR==4) wdir=$1
  if (NR==5) wgust=$1
  if (NR==6) p_hpa=$1
  if (NR==7) sunrise=$1
  if (NR==8) sunset=$1
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
  
  # Output shell variable assignments
  printf "temp_f_formatted=\"%.0f\"; ", temp
  printf "dewpoint_f_formatted=\"%s\"; ", dewpoint
  printf "wdir_formatted=\"%.0f\"; ", wdir
  printf "wspd_formatted=\"%.0f\"; ", wspd
  printf "wgust_str=\"%s\"; ", gust_str
  printf "p_inhg=\"%.2f\"; ", p_hpa*0.0295299830714
  
  # Remove zero-padding from sunrise (07:23 -> 7:23)
  # Sunset in 24hr format is always >= 12, so no zero-padding needed
  sunrise_hr = int(substr(sunrise, 1, 2))
  sunrise_min = substr(sunrise, 4, 2)
  
  printf "sunrise=\"%d:%s\"; ", sunrise_hr, sunrise_min
  printf "sunset=\"%s\"", sunset
}')

# Set all weather items
sketchybar --set weather_temp label="${temp_f_formatted}°F"
sketchybar --set weather_dewpoint label="${dewpoint_f_formatted}°F"
sketchybar --set weather_wind label="${wdir_formatted}° ${wspd_formatted}${wgust_str}MPH"
sketchybar --set weather_pressure label="${p_inhg}\""
sketchybar --set weather_sun label="${sunrise}↑ ${sunset}↓"