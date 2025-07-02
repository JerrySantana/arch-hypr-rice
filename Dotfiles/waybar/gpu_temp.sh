#!/bin/bash

#######################################
## Script to obtain gpu temperature. ##
## Made by: JerrySantana (on Github) ##
#######################################

temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
echo "GPU ${temp}°C"