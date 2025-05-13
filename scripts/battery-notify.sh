#!/bin/bash

BATTERY_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')
CHARGING=$(acpi -b | grep -i "charging")

if [ -z "$CHARGING" ] && [ "$BATTERY_LEVEL" -le 15 ]; then
    notify-send -u critical "Battery low" "Battery is at ${BATTERY_LEVEL}%"
fi
