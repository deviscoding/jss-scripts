#!/bin/bash

### region ############################################ DocBlock
#
# Regenerates the icon cache on MacOS
#
# @source https://gist.github.com/fabiofl/5873100 (inket)
#
### endregion ######################################### DocBlock

### region ############################################ Main Code

find /private/var/folders/ -name com.apple.dock.iconcache -exec rm {} \;
find /private/var/folders/ -name com.apple.iconservices -exec rm -rf {} \;
mv /Library/Caches/com.apple.iconservices.store com.apple.ic
killall Dock

### endregion ######################################### Main Code