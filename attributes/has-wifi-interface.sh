#!/bin/bash

##################################################################
#
# Purpose:  Tests if computer has a WiFi network interface.
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

WIFI=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

if [ -n "${WIFI}" ]; then
echo "<result>TRUE</result>"
else
echo "<result>FALSE</result>"
fi

exit 0