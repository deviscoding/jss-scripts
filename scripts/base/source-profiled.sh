#!/bin/bash

### region ############################################ DocBlock
#
# Sources any scripts in /etc/profile.d when reading /etc/profile.
#
### endregion ######################################### DocBlock

### region ############################################ Variables

PROFILED=/etc/profile.d
PROFILE=/etc/profile

### endregion ######################################### Variables

### region ############################################ Main Code

# Create Directory
if [ ! -d "${PROFILED}" ]; then
  mkdir -p "${PROFILED}"
  chmod 755 "${PROFILED}"
  chown root:wheel "${PROFILE}"
fi

# Create Script
if [ ! -f "${PROFILE}" ]; then
  touch "${PROFILE}"
  chmod 755 "${PROFILE}"
  chown root:wheel "${PROFILE}"
fi

# Check for profile.d inclusion
CHECK=$(grep "${PROFILED}" $PROFILE)
if [ -z "${CHECK}" ]; then
  echo 'for s in /etc/profile.d/*.sh; do if [ -r "$s" ]; then . "$s"; fi; done' >> $PROFILE
fi

exit 0

### endregion ######################################### Main Code