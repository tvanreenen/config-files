#!/bin/sh

URL="https://api.open-meteo.com/v1/forecast?latitude=42.87&longitude=-85.44&daily=sunrise,sunset&current=temperature_2m,relative_humidity_2m,wind_speed_10m,wind_direction_10m,wind_gusts_10m,apparent_temperature,pressure_msl&timezone=auto&forecast_days=1&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"

json="$(curl -s "$URL")" || exit 1

# Extract needed fields
temp_f="$(printf '%s' "$json" | jq -r '.current.temperature_2m')"
rh="$(printf '%s' "$json" | jq -r '.current.relative_humidity_2m')"
feels_f="$(printf '%s' "$json" | jq -r '.current.apparent_temperature')"
wspd="$(printf '%s' "$json" | jq -r '.current.wind_speed_10m')"
wdir="$(printf '%s' "$json" | jq -r '.current.wind_direction_10m')"
wgust="$(printf '%s' "$json" | jq -r '.current.wind_gusts_10m')"
p_hpa="$(printf '%s' "$json" | jq -r '.current.pressure_msl')"
sunrise="$(printf '%s' "$json" | jq -r '.daily.sunrise[0] | split("T")[1]')"
sunset="$(printf '%s' "$json" | jq -r '.daily.sunset[0]  | split("T")[1]')"

# Dew point (Magnus) + pressure to inHg
dewpoint_f="$(awk -v tf="$temp_f" -v rh="$rh" 'BEGIN{
  # F -> C
  T=(tf-32)*5/9;
  RH=rh;
  if (RH<=0) { print "nan"; exit }
  a=17.27; b=237.7;
  g=log(RH/100.0)+(a*T)/(b+T);
  Td=(b*g)/(a-g);
  # C -> F
  printf "%.1f", Td*9/5+32
}')"

p_inhg="$(awk -v p="$p_hpa" 'BEGIN{ printf "%.2f", p*0.0295299830714 }')"

# Format numeric values
temp_f_formatted="$(printf "%.1f" "$temp_f")"
wspd_formatted="$(printf "%.1f" "$wspd")"
wgust_formatted="$(printf "%.1f" "$wgust")"

sketchybar --set "$NAME" label="${temp_f_formatted}°/${dewpoint_f}°  ${wspd_formatted}@${wdir}° G${wgust_formatted}  ${p_inhg}\"  ${sunrise}↑ ${sunset}"↓