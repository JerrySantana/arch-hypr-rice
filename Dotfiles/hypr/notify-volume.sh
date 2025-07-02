#!/bin/bash

##########################################
## Script for volume notifications.     ##
## Made by: JerrySantana (on Github)    ##
##########################################

icon=""
volume=0
muted="false"
iDIR="$HOME/.config/mako/Icons"
NOTIFY_ID_FILE="/tmp/volume_notify_id"

get_volume() {
    volume=$(pamixer --get-volume)
    muted=$(pamixer --get-mute)
}

get_icon() {
    if [[ "$muted" == "true" || "$volume" -eq 0 ]]; then
        icon="$iDIR/volume-mute.png"
    elif (( volume <= 30 )); then
        icon="$iDIR/volume-low.png"
    elif (( volume <= 60 )); then
        icon="$iDIR/volume-mid.png"
    else
        icon="$iDIR/volume-high.png"
    fi
}

# Get volume and icon
get_volume
get_icon

# Create visual bar
if [[ "$muted" == "true" ]]; then
    bar=" Muted"
else
    filled=$((volume / 10))
    empty=$((10 - filled))
    bar=$(printf "%s%s" "$(printf '█%.0s' $(seq 1 $filled))" "$(printf '░%.0s' $(seq 1 $empty))")
    bar="$bar $volume%"
fi

# Read ID and replace previous notification
if [[ -f "$NOTIFY_ID_FILE" ]]; then
    notify_id=$(<"$NOTIFY_ID_FILE")
else
    notify_id=0
fi

# Send notification
new_id=$(notify-send -p -r "$notify_id" -i "$icon" "Volume: $volume%" "$bar")
echo "$new_id" > "$NOTIFY_ID_FILE"
