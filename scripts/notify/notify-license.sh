#!/bin/bash

##################################################################
#
# Purpose:  Notifies of a license that needs to be manually installed.
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

### region ############################################ Input Variable

# Email Address to Send Notification To
IHOST="${2}"
IUSER="${3}"
NOTIFY="${4}"
APPNAME="${5}"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns"

#JAMFHelper
HELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
WINDOW="utility"
HEADING="${APPNAME} License Required"
TITLE="License Needed"
DESCRIPTION="A license is needed before you can use ${APPNAME}.  This license must be installed manually.  A notice has been dispatched to the Information Systems staff, who will contact you to arrange for the license installation within 1 business day."

### endregion ######################################### Input Variables

### region ############################################ Main Code

if [ -n "${NOTIFY}" ]; then
 echo "The user '${IUSER}' on the system '${IHOST}' needs a license for ${APPNAME}." | mail -s "License Needed on ${IHOST}" "${NOTIFY}"
fi

# Display Jamf Helper Window
"${HELPER}" -windowType "${WINDOW}" -title "${TITLE}" -heading "${HEADING}" -description "${DESCRIPTION}" -icon "${ICON}" -button1 "OK"
exit 0

### endregion ######################################### Main Code