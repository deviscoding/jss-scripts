#!/bin/bash

### region ############################################ DocBlock
#
#  Sets the default handler for PDF files to either Acrobat DC,
#  Acrobat Pro XI or Adobe Reader DC, depending on input and
#  and which application is installed.
#
#  @author      Aaron M Jones <aaronj@econoprint.com>
#  @requires    Duti (https://github.com/moretension/duti)
#
### endregion ######################################### DocBlock

### region ############################################ Variables

# Force Based on Input
[ -n "$4" ] && DEFAULT_APP_PDF="$4" || DEFAULT_APP_PDF=""

# Static Paths
PATH_ACROBAT_DC="/Applications/Adobe Acrobat DC/Adobe Acrobat.app"
PATH_ACROBAT_PRO="/Applications/Adobe Acrobat XI Pro/Adobe Acrobat Pro.app"
PATH_ACROBAT_READER="/Applications/Adobe Acrobat Reader DC.app"

### endregion ######################################### Variables

### region ############################################ Dependency Verification

# Test if DUTI is installed
DUTI=$(which duti) || /usr/local/bin/duti
if [ -z "${DUTI}" ] || [ ! -e "${DUTI}" ]; then
  echo "Duti is not installed.  Aborting."
  exit 1
fi

### endregion ######################################### Dependency Verification

### region ############################################ Main Code

# Find Current
CUR_APP_PDF=$($DUTI -x com.adobe.pdf | grep ".app" | tail -1)
[ -n "$($DUTI -x com.adobe.pdf | grep "Preview.app")" ] && ISPREVIEW=true || ISPREVIEW=false

# If not forcing, pick app.
if [ -z "${DEFAULT_APP_PDF}" ]; then
  ISPREVIEW=$($DUTI -x com.adobe.pdf | grep "Preview.app")
  if $ISPREVIEW || [ -z "${CUR_APP_PDF}" ]; then
    if [ -d "${PATH_ACROBAT_DC}" ]; then
      DEFAULT_APP_PDF="${PATH_ACROBAT_DC}"
    elif [ -d "${PATH_ACROBAT_PRO}" ]; then
      DEFAULT_APP_PDF="${PATH_ACROBAT_PRO}"
    elif [ -d "${PATH_ACROBAT_READER}" ]; then
      DEFAULT_APP_PDF="${PATH_ACROBAT_READER}"
    else
      echo "No Version of Acrobat or Acrobat Reader found!"
      exit 1
    fi
  else
    echo "Preference Already Set to ${CUR_APP_PDF}"
    exit 0
  fi
fi

# Get the bundle for the given app
if [ -n "${DEFAULT_APP_PDF}" ]; then
  if [ -d "${DEFAULT_APP_PDF}" ]; then
    APP_BUNDLE=$(mdls -n kMDItemCFBundleIdentifier -r "${DEFAULT_APP_PDF}")
  else
    echo "Specified app ${DEFAULT_APP_PDF} does not exist."
    exit 1
  fi
fi

# Set the default
if [ -n "${APP_BUNDLE}" ]; then
  echo "Setting PDFs to open with: ${DEFAULT_APP_PDF}"
  $DUTI -s "$APP_BUNDLE" com.adobe.pdf all
  STATUS=$?
  if [ $STATUS != 0 ]; then
    echo "ERROR setting default PDF application."
    exit 1
  fi
fi

exit 0

### endregion ######################################### Main Code