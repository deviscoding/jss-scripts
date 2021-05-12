#!/bin/bash

##################################################################
#
# Purpose:  Grabs Content Caching Server IP Addresses
# Source:   Gets the SUS Catalog URL
#
##################################################################

### region ############################################ Main Code

SUS=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate CatalogURL 2>/dev/null)
if [ -z "$SUS" ]; then
  echo "<result>Apple</result>"
else
  echo "<result>$SUS</result>"
fi

exit 0

### endregion ######################################### Main Code