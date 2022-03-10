#!/bin/bash

if [ -f '/var/db/.AppleSetupDone' ]; then
  BACKUP_DATE=$(date -r /var/db/.AppleSetupDone +"%Y-%m-%d %H:%M:%S")
else
  BACKUP_DATE="2001-03-24 00:00:00"
fi

BACKUP_ENABLED=$(/usr/bin/defaults read /Library/Preferences/com.apple.TimeMachine AutoBackup)
if [ "${BACKUP_ENABLED}" -eq "1" ]; then
  MAC_MAJOR=$(sw_vers -productVersion | cut -d'.' -f1)
  if [ "$MAC_MAJOR" -gt "10" ]; then
    # Format in Monterey is Y-m-d-His.backup
    TRY_DATE=$(tmutil latestbackup 2>&1 | cut -d '.' -f "1")
  else
    # Format in Catalina is /Volumes/TimeMachine/Backups.backup/host/Y-m-d-His
    TRY_DATE=$(basename "$(tmutil latestbackup 2>&1)")
  fi
  if [ "${TRY_DATE}" != "Unable to locate machine directory for host" ] && [ "${TRY_DATE}" != "Failed to mount backup destination, error: Error Domain=com" ]; then
    BACKUP_DATE=$(date -f "%Y-%m-%d-%H%M%S" "${TRY_DATE}" +"%Y-%m-%d %H:%M:%S")
  elif [ -f "/Library/Preferences/com.apple.TimeMachine.plist" ]; then
    LAST=$(defaults read /Library/Preferences/com.apple.TimeMachine.plist Destinations 2> /dev/null | awk '/SnapshotDates/,/;/' | tail -n 2 | head -n 1 | awk '{$1=$1};1' | sed 's/\"//' | sed 's/\"//')
    if [ -n "$LAST" ]; then
      BACKUP_DATE=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$LAST" "+%Y-%m-%d %H:%M:%S")
    fi
  fi
fi

echo "<result>${BACKUP_DATE}</result>"
exit 0
