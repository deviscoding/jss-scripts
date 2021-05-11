#!/bin/bash

##################################################################
#
# Purpose:  Notifies of network users without a mobile user.
# Author:   Aaron J <aaronj@econoprint.com>
#
##################################################################

USERSTR="$(dscl . list /Users | grep -v '^_')"
USERS=()
IGNORE=()
NOTIFY="${4}"
INTERVAL=3

# Read users into
while read -r line; do
   USERS+=("$line")
done <<< "$USERSTR"

# Loop through user directories
for USER_DIR in /Users/*; do
	# It's a User Folder
	if [ -d "${USER_DIR}/Desktop/" ]; then
		# Not listed as local user
		TUSER=$(basename "${USER_DIR}")
		if [[ ! "${USERS[@]}" =~ "${TUSER}" ]]; then
			# Not in the ignore list
			if [[ ! "${IGNORE[@]}" =~ "${i}" ]]; then
				# And it's not a Systems User
				ISIS=$(groups "${TUSER}")
				if [[ ! "${ISIS}" =~ "Systems" ]]; then
					# And there isn't a file telling us to ignore this
					if [ ! -f "${USER_DIR}/.nomobile" ] && [ ! $(find "${USER_DIR}" -mtime -"${INTERVAL}" -type f -name ".notify_mobile") ]; then
						if [ -n "${NOTIFY}" ]; then
							/usr/bin/touch "${USER_DIR}/.notify_mobile"
		  				echo "The user '${TUSER}' does not have a mobile profile on ${HOSTNAME}." | mail -s "Mobile Profile Missing" "${NOTIFY}"
						else
							exit 1
						fi
					else
						# Clean up after ourselves
						if [ ! -z "${NOTIFY}" ]; then
							rm "${USER_DIR}/.notify_mobile"
						fi
					fi
				fi
			fi
		fi
	fi
done

exit 0