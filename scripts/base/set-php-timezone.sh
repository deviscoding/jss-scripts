#!/bin/bash

##################################################################
#
# Purpose:  Sets the php.ini timezone to the computer's timezone.
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

if [ ! -f /etc/php.ini ]; then
  cp /etc/php.ini.default /etc/php.ini
fi

ZONE=$(/bin/ls -l /etc/localtime|/usr/bin/cut -d"/" -f8,9)
timezone="${ZONE//@/\\@}"
sed -i '' "s@;date\.timezone =.*@date\.timezone = $timezone@g" /etc/php.ini
exit 0