#!/bin/bash

##################################################################
#
# Purpose:  Installs Composer globally, and moves to /usr/local/bin
# Source:   Composer Website with changes for better feedback
#
##################################################################

if [ ! -f /usr/local/bin/composer ]; then
  printf "Downloading Composer Installer... "
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
  echo "[DONE]"
  printf "Verifying Checksum..."
  EXPECTED_CHECKSUM="$(curl --silent https://composer.github.io/installer.sig)"
  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    echo "[NO MATCH]"
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
  else
    echo "[MATCH]"
  fi

  printf "Installing Composer..."
  php composer-setup.php --quiet
  RESULT=$?
  rm composer-setup.php
  if [ $RESULT -eq 0 ]; then
    mv composer.phar /usr/local/bin/composer
    echo "[SUCCESS]"
  else
    echo "[ERROR]"
    exit 1
  fi
else
  printf "Checking Latest Version..."
  LATEST=$(curl -sL https://api.github.com/repos/composer/composer/releases/latest | jq -r '.tag_name')
  echo "[$LATEST]"
  printf "Checking Current Version..."
  CURRENT=$(ssh sysadmin@localhost /usr/local/bin/composer --version | awk '{ print $3 }')
  echo "[$CURRENT]"
  if [ "$LATEST" != "$CURRENT" ]; then
    printf "Updating Composer..."
    /usr/local/bin/composer self-update --stable
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo "[SUCCESS]"
    else
      echo "[ERROR]"
      exit 1
    fi
  else
    echo "No Update Needed!"
  fi
fi
exit 0


