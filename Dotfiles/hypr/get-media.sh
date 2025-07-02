#!/bin/bash

#########################################
## Script for media type detection and ##
## media notifications using Mako.     ##
## Made by: JerrySantana (on Github)   ##
#########################################

NOTIFY_ID_FILE="/tmp/media_notify_id"
music_icon="$HOME/.config/mako/Icons/music.png"

# Detect current mediaplayer
player=$(playerctl -l 2>/dev/null | head -n 1)

# Obtain metadata
title=$(playerctl -p "$player" metadata title 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
album=$(playerctl -p "$player" metadata xesam:album 2>/dev/null)
source=$(playerctl -p "$player" metadata | grep "xesam:url" | awk '{print $3}' | cut -d '/' -f3)

# Basic media type detector
if [[ "$player" == *"mpv"* || "$title" =~ \.(mp4|mkv|webm|avi|mov)$ || "$source" =~ youtube ]]; then
    icon=""
    tipo=" Video"
else
    icon="󰎄"
    tipo="🎵 Music"
fi

# Format notification and content
header="$tipo - $icon $source"
body=""

if [[ -n "$artist" ]]; then
    body=" $artist"
    if [[ -n "$album" ]]; then
        body="$body 󰀥 $album"
    fi 
fi

if [[ -n "$title" ]]; then
    if [[ -n "$body" ]]; then
        body="$body\n$title"
    else
        body="$title"
    fi
fi


# Read ID and replace previous notification
if [[ -f "$NOTIFY_ID_FILE" ]]; then
    notify_id=$(<"$NOTIFY_ID_FILE")
    # Validate integer
    if ! [[ "$notify_id" =~ ^[0-9]+$ ]]; then
        notify_id=0
    fi
else
    notify_id=0
fi


# Send notification
new_id=$(notify-send -p -r "$notify_id" -i "$music_icon" "$header" "$body")
echo "$new_id" > "$NOTIFY_ID_FILE"