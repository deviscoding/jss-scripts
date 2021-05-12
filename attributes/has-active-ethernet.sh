#!/bin/bash

# Find device on hardware irregardless of model
EXCLUDE_DEVICE=$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/egrep -A2 'Airport|Wi-Fi|Bluetooth' | /usr/bin/awk '/Device/ { print $2 }')
ETHER_DEVICE=$(networksetup -listallhardwareports | grep 'en' | grep -v "${EXCLUDE_DEVICE}" | grep -o en.)

# Define non-wireless IP status.
ETHERNET_IP=$(for i1 in ${ETHER_DEVICE};do
  echo $(ifconfig "${i1}" | grep 'inet' | grep -v '127.0.|169.254.' | awk '{ print $2 }')
done)

if [ -n "${ETHERNET_IP}" ]; then
  echo "<result>TRUE</result>"
else
  echo "<result>FALSE</result>"
fi

exit 0