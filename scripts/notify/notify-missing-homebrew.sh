#!/bin/bash

##################################################################
#
# Purpose:  Notifies of missing missing homebrew installation
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

### region ############################################ Input Variable

# Email Address to Send Notification To
NOTIFY="${4}"

### endregion ######################################### Input Variables

### region ############################################ Main Code

BREW=$(which brew)
if [ -z "${BREW}" ]; then
 echo "The host '${2}' needs Homebrew installed manually." | mail -s "Homebrew Missing on ${2}" "${NOTIFY}"
fi

exit 0

### endregion ######################################### Main Code