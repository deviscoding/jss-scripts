#!/bin/bash

##################################################################
#
# Purpose:  Backs up Important Parts of Thunderbird Profile Config
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

TUSER="${3}"
USER_TB="/Users/${TUSER}/Library/Thunderbird/Profiles/"
# Number of Backups to Keep
KEEP="${4}"
if [ -z "${KEEP}" ]; then
 KEEP=6
fi

### region ############################################ Dependencies

([ -z "$(which jez)" ] && jamf policy --trigger InstallJez) && ([ -z "$(which jez)" ] && echo "ERROR: JEZ Not Installed") && exit 1

# shellcheck source=../../functions/_jez.sh
source "$(jez prep)"

### endregion ######################################### Dependencies

if [ -d "${USER_TB}" ]; then
  d=$(/bin/date +\%Y\%m\%d)
  # Backup Files in Each Profile
  for PDIR in "${USER_TB}"/*; do
		if [ -d "${PDIR}" ]; then

      # Backup Preferences File
      if [ -f "${PDIR}/prefs.js" ]; then
        cp prefs.js "prefs-${d}.js.bak"
        $JEZ chown:user "${PDIR}/prefs-${d}.js.bak" --user "${TUSER}" --quiet
      fi
      # Backup Address Book
      if [ -f "${PDIR}"/abook.mab ]; then
        cp abook.mab "abook-${d}.mab.bak"
        $JEZ chown:user "${PDIR}/abook-${d}.mab.bak" --user "${TUSER}" --quiet
      fi
      # Backup Collected Addresses
      if [ -f "${PDIR}"/history.mab ]; then
        cp history.mab "history-${d}.mab.bak"
        $JEZ chown:user "${PDIR}/history-${d}.mab.bak" --user "${TUSER}" --quiet
      fi

      # Eliminate older backup files
      ls -tp "${PDIR}"/prefs-*.js.bak | grep -v '/$' | tail -n +$KEEP | tr '\n' '\0' | xargs -0 rm --
      ls -tp "${PDIR}"/abook-*.mab.bak | grep -v '/$' | tail -n +$KEEP | tr '\n' '\0' | xargs -0 rm --
      ls -tp "${PDIR}"/history-*.mab.bak | grep -v '/$' | tail -n +$KEEP | tr '\n' '\0' | xargs -0 rm --
    fi
  done
  exit 0
else
  echo "ERROR: No Thunderbird Profiles.  Exiting..."
  exit 1
fi