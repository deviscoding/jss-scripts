#!/bin/bash

##################################################################
#
# Purpose:  Notes the Adobe Flash Version if installed.
# Source:   https://www.jamf.com/jamf-nation/third-party-products/files/698/get-flash-version
#
##################################################################

### region ############################################ Variables

DEFAULT=""
APPPATH="/Library/Internet\ Plug-Ins/Flash\ Player.plugin"

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