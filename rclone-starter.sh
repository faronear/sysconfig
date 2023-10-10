#!/bin/bash

echo "=== rclone [i] to install, [s] to sync, [c] to copy, [w] to web gui" 
read -p ">>> " ACTION_TYPE
if [ "$ACTION_TYPE" = 'i' ]
then
  sudo -v ; curl https://rclone.org/install.sh | sudo bash
elif [[ "$ACTION_TYPE" = 's' || "$ACTION_TYPE" = 'c' ]]
then
  if [ "$ACTION_TYPE" = 's' ]
  then 
    RC_CMD='sync'
  elif [  ]
  then
    RC_CMD='copy'
  fi
  read -p "rclone $RC_CMD from source >>> " SOURCE_PATH
  read -p "rclone $RC_CMD into target >>> " TARGET_PATH
#  read -p "rclone $RC_CMD  with max-age >>> " MAX_AGE ## 发现用了 max-age 并没有提升速度，反而略有下降，即使对大量现有文件和少量更新文件
  read -p "rclone $RC_CMD excluding (folders must end with /) >>> " EXCLUDING
  
  echo
  echo "*****************************"
  echo "rclone $RC_CMD $SOURCE_PATH $TARGET_PATH -P -L --create-empty-src-dirs --exclude=._* --exclude=.DS_Store --exclude={node_modules/,.deploy_git/,unpackage/,$EXCLUDING}"
  echo "*****************************"
  echo "Starting? [y] for yes, [anything else] for quit"
  read -p ">>> " YES_OR_NOT
  if [ "$YES_OR_NOT" = 'y' ]
  then
    echo "****************** [rclone $RC_CMD] Start: `date -u -Iseconds` *****************"
    rclone $RC_CMD $SOURCE_PATH $TARGET_PATH -P -L --create-empty-src-dirs --exclude=._* --exclude=.DS_Store --exclude={node_modules/,.deploy_git/,unpackage/,$EXCLUDING}
    echo "****************** [rclone $RC_CMD] Start: `date -u -Iseconds` *****************"
  fi
elif [ "ACTION_TYPE" = 'w' ]
then
  rclone rcd --rc-web-gui
fi
