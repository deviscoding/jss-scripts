#!/bin/bash

### region ############################################ DOCBLOCK
#
# Gets list of active displays
#
# @author Aaron J <aaronj@econoprint.com>
#
### endregion ######################################### DOCBLOCK

### region ############################################ Main Code

DLIST=$(system_profiler SPDisplaysDataType -json | jq .SPDisplaysDataType[0].spdisplays_ndrvs[]._name -r | tr '\n' '|' | sed 's/|$//')
if [ -n "$DLIST" ]; then
  echo "<result>$DLIST</result>"
else
  echo "<result>None</result>"
fi
exit 0

### endregion ######################################### Main Code