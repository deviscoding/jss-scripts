#!/bin/bash

##################################################################
#
# Purpose:  Gets the version of the app configured in the APPNAME
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

### region ############################################ Variables

APPNAME=""
APPPATH="/Applications/${APPNAME}"
DEFAULT="None"

if [ -z "${APPNAME}" ]; then
  echo "<result>ERROR</result>"
  exit 1
fi

### endregion ######################################### Variables

### region ############################################ Functions

function getAppVersion() {
  local TA_PATH CURR_VER
  TA_PATH=$1
  CURR_VER=${2-None}
  if [ -f "$TA_PATH/Contents/Info.plist" ]; then
	  CURR_VER=$(/usr/bin/defaults read "$TA_PATH/Contents/Info" CFBundleShortVersionString)
  fi

  echo "$CURR_VER"
}

### endregion ######################################### Functions

### region ############################################ Main Code

CFBundleVersion=$(getAppVersion "${APPPATH}" "${DEFAULT}")
echo "<result>$CFBundleVersion</result>"
exit 0

### endregion ######################################### Main Code