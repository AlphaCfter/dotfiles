#!/bin/bash
# Improved Bluetooth Connection Status Script

# Check if bluetoothctl is available
if ! command -v bluetoothctl &> /dev/null; then
    echo "Enable Bluetooth"
    exit 1
fi

# Function to get connected device
get_connected_device() {
    # Try multiple methods to get connected device
    local device
    
    # Method 1: Direct bluetoothctl devices Connected parsing
    device=$(bluetoothctl devices Connected | awk '{for(i=3;i<=NF;i++){printf "%s ", $i}}' | sed 's/ $//')
    
    # Method 2: If method 1 fails, try alternate parsing
    if [ -z "$device" ]; then
        device=$(bluetoothctl devices | grep "Connected" | awk '{for(i=3;i<=NF;i++){printf "%s ", $i}}' | sed 's/ $//')
    fi
    
    # Method 3: If still empty, get the device from info
    if [ -z "$device" ]; then
        device=$(bluetoothctl info | grep "Name:" | cut -d: -f2 | xargs)
    fi
    
    echo "$device"
}

# Check Bluetooth connection status
status=$(bluetoothctl show | grep "Powered: yes" > /dev/null && echo "powered" || echo "off")
if [ "$status" == "off" ]; then
    echo "Disconnected"
    exit 0
fi

# Try to get the connected device name
connected_device=$(get_connected_device)
if [ -n "$connected_device" ]; then
    echo "$connected_device"
else
    echo "Disconnected"
fi