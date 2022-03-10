#!/bin/bash

### region ############################################ DOCBLOCK
#
# Gets the version of the php-cs-fixer binary, if installed.
#
# @author Aaron J <aaronj@econoprint.com>
#
### endregion ######################################### DockBlock

### region ############################################ Variables

# Begin Customization
DEFAULT="None"
BINARY_NAME="php-cs-fixer"
VERSION_FLAG="-V" # Include single or double dashes as applicable
VERSION_GREP="" # Cuts to only the lines that include this result
VERSION_LINE="" # Only includes the given line number
VERSION_COLUMN="4" # Cuts to this space delimited column of the results
VERSION_PIPE="" # Additional string manpulation.  Do not include leading pipe!!
PATH_ADDITONS="/usr/local/bin:/opt/homebrew/bin:/opt/local/bin" # Common paths for homebrew and macports

##### End Customization

# Default the Version
VERSION="$DEFAULT"
# Determine where the binary is using, including paths from our additions
BINARY_PATH=$(PATH="$PATH:$PATH_ADDITONS" && /usr/bin/which "$BINARY_NAME")
if [ -z "$BINARY_PATH" ]; then
  # Well, none of the existing paths nor our path additions worked.
  # Let's give one last effort using path_helper
  if [ -x /usr/libexec/path_helper ]; then
    # shellcheck disable=SC2046
    eval "$(/usr/libexec/path_helper -s)"
    BINARY_PATH=$(which "$BINARY_NAME")
  fi
fi

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
  # shellcheck disable=SC2001
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