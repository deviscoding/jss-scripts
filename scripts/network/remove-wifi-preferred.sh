#!/bin/bash

##################################################################
#
# Purpose:  Removes Wifi SSID from Preferred Networks
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

## Input Variables --- Script intended for use in Jamf; $1, $2, $3 come from Jamf

# The SSID to remove from preferred networks
SSID="${4}"

## Internal Variables

# Name of WiFi Interface
WIFI=$(/usr/sbin/networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
# Devices to Exclude from Wired Interface Query
EXCLUDE_DEVICE=$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/egrep -A2 'Airport|Wi-Fi|Bluetooth' | /usr/bin/awk '/Device/ { print $2 }')
# Name of Wired Interface
ETHER_DEVICE=$(/usr/sbin/networksetup -listallhardwareports | grep 'en' | grep -v "${EXCLUDE_DEVICE}" | grep -o en.)
# Determines if Wired Interface has an IP Address
ETHERNET_IP=$(for i1 in ${ETHER_DEVICE};do
  echo $(ifconfig "${i1}" | grep 'inet' | grep -v '127.0.|169.254.' | awk '{ print $2 }')
done)

## Script Actions

# Remove the Network
networksetup -removepreferredwirelessnetwork $WIFI "${SSID}"
REMOVAL_STATUS=$?

# Cycle the WiFi Interface if Connected to Ethernet
if [ $REMOVAL_STATUS -eq 0 ] && [ -n "${ETHERNET_IP}" ]; then
  /usr/sbin/networksetup -setairportpower "${WIFI}" off
  /usr/sbin/networksetup -setairportpower "${WIFI}" on
fi

# Exit Properly
if [ ! $REMOVAL_STATUS -eq 0 ]; then 
  echo "Removing ${SSID} WiFi Network from Preferred Failed.  Exiting...";
  exit 1
fi

exit 0