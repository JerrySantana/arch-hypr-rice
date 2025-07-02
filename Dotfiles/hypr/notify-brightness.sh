#!/bin/bash

##########################################
## Script for brightness notifications. ##
## Made by: JerrySantana (on Github)    ##
##########################################

icon=""
brightness=0
max_brightness=0
iDIR="$HOME/.config/mako/Icons"
NOTIFY_ID_FILE="/tmp/brightness_notify_id"

get_brightness() {
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
}

get_icon() {
    if (( brightness <= 20 )); then
        icon="$iDIR/brightness-20.png"
    elif (( brightness <= 40 )); then
        icon="$iDIR/brightness-40.png"
    elif (( brightness <= 60 )); then
        icon="$iDIR/brightness-60.png"
    elif (( brightness <= 80 )); then
        icon="$iDIR/brightness-80.png"
    else
        icon="$iDIR/brightness-100.png"
    fi
}

get_brightness
get_icon

percent=$((brightness * 100 / max_brightness))

# Create visual bar
filled=$(($percent / 10))
empty=$((10 - filled))
bar=$(printf "%s%s" "$(printf '█%.0s' $(seq 1 $filled))" "$(printf '░%.0s' $(seq 1 $empty))")
bar="$bar $percent%"

# Read ID and replace previous notification
if [[ -f "$NOTIFY_ID_FILE" ]]; then
    notify_id=$(<"$NOTIFY_ID_FILE")
else
    notify_id=0
fi

# Send notification
new_id=$(notify-send -p -r "$notify_id" -i "$icon" "Brightness: $brightness%" "$bar")
echo "$new_id" > "$NOTIFY_ID_FILE"