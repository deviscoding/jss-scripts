#!/bin/bash

##################################################################
#
# Purpose:  Grabs Content Caching Server IP Addresses
# Source:   https://github.com/krypted/cachecheck/blob/master/cachecheck.sh
#
##################################################################

### region ############################################ Variables

CACHE_TYPE="shared"
CACHE_GREP="${CACHE_TYPE} caching: yes"
BIN_PATH="/usr/bin/AssetCacheLocatorUtil"

### endregion ######################################### Variables

### region ############################################ Main Code

RESULT=$("${BIN_PATH}" 2>&1 | grep guid | grep "${CACHE_GREP}" | awk '{print$4}' | sed 's/^\(.*\):.*$/\1/' | uniq)
echo "<result>${RESULT}</result>"
exit 0

### endregion ######################################### Main Code