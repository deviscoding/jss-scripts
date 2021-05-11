#!/bin/bash

### region ############################################ DocBlock
#
# Installs the latest Mozilla Thunderbird, using
# JEasy for the heavy lifting.
#
# Credit to Joe Farage for the concepts in the version function(s)
# which were adapted from his scripts, written 3/18/2015.
#
### endregion ######################################### DocBlock

### region ############################################ Variables

# choose language (en-US, fr, de)
lang=""
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 1 AND, IF SO, ASSIGN TO "lang"
if [ "$4" != "" ] && [ "$lang" == "" ]; then
	lang=$4
else
	lang="en-US"
fi

### endregion ######################################### Variables

### region ############################################ Dependencies

([ -z "$(which jez)" ] && jamf policy --trigger InstallJez) && ([ -z "$(which jez)" ] && echo "ERROR: JEZ Not Installed") && exit 1

# shellcheck source=../../functions/_jez.sh
source "$(jez prep)"

### endregion ######################################### Dependencies

### region ############################################ Functions

function getLatestVersion() {
  local OSvers_URL userAgent lver

	## Get OS version and adjust for use with the URL string
	OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

	## Set the User Agent string for use with curl
	userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

	# Get the latest version of Thunderbird available from Thunderbird page.
	lver=$(/usr/bin/curl -s -A "$userAgent" "https://www.thunderbird.net/${lang}/thunderbird/all/" | grep 'data-thunderbird-version' | sed -e 's/.* data-thunderbird-version="\(.*\)".*/\1/' -e 's/\"//' | /usr/bin/awk '{print $1}')

echo "$lver"

  return 0
}

### endregion ######################################### Functions

# Display Message
echo ""
$JMSG "Checking Current Version"
# Get Current Version
CURRENT=$(getLatestVersion)
# Display Badge & Exit if No Version Given
([ -n "${CURRENT}" ] && $JSUCCESS) || ($JERROR && exit 1)

# Set Variables
APP_URL="https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${CURRENT}/mac/${lang}/Thunderbird%20${CURRENT}.dmg"
APP_PATH="/Applications/Thunderbird.app"

# Install DMG
if $JEZ install:dmg "${APP_PATH}" "${APP_URL}" --target="${CURRENT}"; then
  echo "" && exit 0
else
  echo "" && exit 1
fi