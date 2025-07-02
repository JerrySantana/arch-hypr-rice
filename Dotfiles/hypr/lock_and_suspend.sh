#!/bin/bash

#########################################
## Script for pausing media and lock   ##
## session, before suspending.         ##
## Made by: JerrySantana (on Github)   ##
#########################################

# Pause music or videos before lock session
playerctl pause

# Run hyprlock
hyprlock &

# Wait a second disable external monitor, wait one more second
sleep 1
hyprctl dispatch dpms off DP-1
sleep 1

# System suspend
systemctl suspend