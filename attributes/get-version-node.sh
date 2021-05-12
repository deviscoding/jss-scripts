#!/bin/bash

### region ############################################ DOCBLOCK
#
# Gets the installed version of Node.js
#
# @author Aaron J <aaronj@econoprint.com>
#
### endregion ######################################### DockBlock

### region ############################################ Variables

# Begin Customization
DEFAULT="None"
BINARY_NAME="node"
VERSION_FLAG="-v" # Include single or double dashes as applicable
VERSION_GREP="" # Cuts to only the lines that include this result
VERSION_LINE="" # Only includes the given line number
VERSION_COLUMN="" # Cuts to this space delimited column of the results
VERSION_PIPE="" # Additional string manpulation.  Do not include leading pipe!!

# End Customization
BINARY_PATH="/usr/local/bin/${BINARY_NAME}"
VERSION="$DEFAULT"

### endregion ######################################### Variables

### region ############################################ Main Code

# Get Command String
if [ -n "${BINARY_PATH}" ]; then
  VERSION=$($BINARY_PATH "$VERSION_FLAG")

  # Add Grep
  if [ -n "${VERSION_GREP}" ]; then
    VERSION=$(echo "$VERSION" | grep "$VERSION_GREP")
  fi

  # Cut to Line
  if [ -n "${VERSION_LINE}" ]; then
    VERSION=$(echo "$VERSION" | head -n "$VERSION_LINE")
  fi

  # Cut to Column
  if [ -n "${VERSION_COLUMN}" ]; then
    VERSION=$(echo "$VERSION" | cut -d ' ' -f "$VERSION_COLUMN")
  fi

  # Add additional pipes
  if [ -n "${VERSION_PIPE}" ]; then
    VERSION=$(echo "$VERSION" | $VERSION_PIPE)
  fi

  # Remove Leading V
  VERSION=$(echo "$VERSION" | sed 's/^v//')

  # Test for Version
  if [ -z "$VERSION" ]; then
    VERSION="Error"
  fi
fi

# Output Result
echo "<result>$VERSION</result>"
exit 0

### endregion ######################################### Main Code