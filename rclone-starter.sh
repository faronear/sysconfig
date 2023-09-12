#!/bin/bash

echo "=== rclone <i> to install, <s> to sync, <w> to web gui" 
read -p ">>> " ACTION_TYPE
if [ "$ACTION_TYPE" = 'i' ]
then
  sudo -v ; curl https://rclone.org/install.sh | sudo bash
elif [ "$ACTION_TYPE" = 's' ]
then
  echo "rclone sync from source:"
  read -p ">>> " SOURCE_PATH
  echo "rclone sync to target:"
  read -p ">>> " TARGET_PATH
  echo "rclone sync with max-age:"
  read -p ">>> " MAX_AGE

  echo
  echo "*****************************"
  echo "rclone sync $SOURCE_PATH $TARGET_PATH -P -L --create-empty-src-dirs --max-age=$MAX_AGE --exclude=._* --exclude=.DS_Store --exclude=node_modules"
  echo "*****************************"
  echo "Start cloning? <y> for yes, <anything else> for quit"
  read -p ">>> " YES_OR_NOT
  if [ "$YES_OR_NOT" = 'y' ]
  then
    rclone sync $SOURCE_PATH $TARGET_PATH -P -L --create-empty-src-dirs --max-age=$MAX_AGE --exclude=._* --exclude=.DS_Store --exclude={node_modules/,.deploy_git/,unpackage/}
  fi
elif [ "ACTION_TYPE" = 'w' ]
then
  rclone rcd --rc-web-gui
fi
