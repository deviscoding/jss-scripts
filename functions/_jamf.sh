# shellcheck shell=bash
_TPUT=""

### region ############################################ CLI Feedback Functions

function write() {
  printf "%-50s " "$1"
}

function println() {
  [ -z "$_TPUT" ] && _TPUT=$(which tput)
  if [ -z "$TERM" ] || [ "$TERM" == "dumb" ]; then
    echo "[${2}]"
  else
    printf "["; $_TPUT setaf "$1"; printf "%s" "${2}"; $_TPUT sgr0; echo "]"
  fi
}

function successln() {
  println 2 "${1}"
}

function errorln() {
  println 1 "${1}"
}

### endregion ######################################### CLI Feedback Functions

### region ############################################ Download Functions

function getCpuType() {
  local UNAME RETVAL
  UNAME=$(/usr/bin/uname -m)
  if [ "$UNAME" = "x86_64" ] || [ "$UNAME" = "i386" ]; then
    RETVAL="intel"
  elif [ "$UNAME" = "arm64" ]; then
    RETVAL="apple"
  else
    RETVAL="unknown"
  fi

  echo $RETVAL
  return 0
}

function isApple() {
  local UNAME
  UNAME=$(/usr/bin/uname -m)
  if [ "$UNAME" = "arm64" ]; then
    return 0 #true
  else
    return 1 #false
  fi
}

function isIntel() {
  local UNAME
  UNAME=$(/usr/bin/uname -m)
  if [ "$UNAME" = "i386" ] || [ "$UNAME" = "x86_64" ]; then
    return 0 #true
  else
    return 1 #false
  fi
}

function doDownloadCleanup() {
  local TPKG
  TPKG=$1
  if [ -n "${TPKG}" ]; then
    if [ -f "/tmp/${TPKG}" ]; then
      /bin/rm "/tmp/${TPKG}"
      if [ -f "/tmp/${TPKG}" ]; then
        return 1
      fi
    fi

    return 0
  else
    echo "No download filename provided.  Exiting..."
    exit 1
  fi
}

function doInstallPkg() {
  local TPKG IPATH ISTATUS
  TPKG=$1
  IPATH=$2
  if [ -n "$TPKG" ]; then
    installer -allowUntrusted -pkg "/tmp/${TPKG}" -target / 1>/dev/null
    ISTATUS=$?
    if [ "$ISTATUS" -eq "0" ]; then
      if [ -d "$IPATH" ]; then
        return 0
      fi
    fi

    return 1
  else
    echo "Path for installation package not provided! Exiting..."
    exit 1
  fi
}

function getDownload() {
  local TPKG TURL OS_VER UAGENT
  TURL=$1
  TPKG=$2
  OS_VER=$( sw_vers -productVersion | sed 's/[.]/_/g' )
  UAGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OS_VER}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

  if [ -n "${TPKG}" ] && [ -n "${TURL}" ]; then
    /usr/bin/curl -s -A "${UAGENT}" -o "/tmp/${TPKG}" "${TURL}" 1>/dev/null
    if [ -f "/tmp/${TPKG}" ]; then
      return 0;
    else
      return 1;
    fi
  else
    echo "URL or Filename not provided!  Exiting..."
    exit 1
  fi
}

### endregion ######################################### Download Functions

### region ############################################ Ownership Functions

function getGroup() {
  local CMD UGROUP
  CMD="\$a=posix_getgrgid(filegroup('$1'));echo \$a['name'];"
  UGROUP=$(php -r "$CMD")

  echo "$UGROUP"
}

function ensureUserOwner {
  local RETVAL TUSER TFILE UDIR TGROUP OSTATUS GSTATUS
  RETVAL=0
  TUSER=$1
  TFILE=$2
  UDIR="/Users/${TUSER}"
  if [ -f "${TFILE}" ] || [ -d "${TFILE}" ]; then
    TGROUP=$(getGroup "${UDIR}")
    chown -R "${TUSER}" "${TFILE}"
    OSTATUS=$?
    chgrp -R "$TGROUP" "${TFILE}"
    GSTATUS=$?
    if [ $OSTATUS != 0 ] || [ $GSTATUS != 0 ]; then
      RETVAL=1
    fi
  else
    RETVAL=2
  fi

  return $RETVAL
}

### endregion ######################################### Ownership Functions

### region ############################################ Application Functions

### region ############################################ Application Functions

function getBundleShortVersion() {
  local TA_PATH CURR_VER
  TA_PATH=$1
  CURR_VER=${2-None}
  if [ -f "$TA_PATH/Contents/Info.plist" ]; then
	  CURR_VER=$(/usr/bin/defaults read "$TA_PATH/Contents/Info" CFBundleShortVersionString)
  fi

  echo "$CURR_VER"
}

function getBundleVersion() {
  local TA_PATH CURR_VER
  TA_PATH=$1
  CURR_VER=${2-None}
  if [ -f "$TA_PATH/Contents/Info.plist" ]; then
	  CURR_VER=$(/usr/bin/defaults read "$TA_PATH/Contents/Info" CFBundleVersion)
  fi

  echo "$CURR_VER"
}

### endregion ######################################### Application Functions

### endregion ######################################### Application Functions