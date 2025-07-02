#!/bin/bash

##########################################
## Script for media events detection    ##
## (Play, Pause, Next, Previous, Stop). ##
## Made by: JerrySantana (on Github)    ##
##########################################

# Path to script that detects media changes 
MEDIA_SCRIPT="$HOME/.config/hypr/get-media.sh"

# Listenning for media events
playerctl --follow metadata | while read -r line; do
    # Run script only if a title is detected (when it starts playing)
    if [[ "$line" == *"xesam:title"* ]]; then
        bash "$MEDIA_SCRIPT"
    fi
done
