#!/bin/bash

##################################################################
#
# Purpose:  Provides version of Adobe Illustrator 2018, as the
#           AppName is identical for 2018-2021
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

### region ############################################ Variables

YEAR="2020"
DEFAULT="None"

[ "$YEAR" -lt 2019 ] && CC=" CC" || CC=""
APPPATH="/Applications/Adobe Illustrator$CC $YEAR/Adobe Illustrator.app"

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