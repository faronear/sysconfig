#!/bin/bash

echo "=== rclone [i] to install, [s] to sync, [c] to copy, [w] to web gui, [else] to quit" 
read -p ">>> " ACTION_TYPE
if [ "$ACTION_TYPE" = 'i' ]
then
  sudo -v ; curl https://rclone.org/install.sh | sudo bash
elif [[ "$ACTION_TYPE" = 's' || "$ACTION_TYPE" = 'c' ]]
then
  if [ "$ACTION_TYPE" = 's' ]
  then 
    RC_CMD='sync'
  elif [ "$ACTION_TYPE" = 'c' ]
  then
    RC_CMD='copy'
  fi
  
  echo
  echo "=== from source (default ./)"; read -p ">>> " SOURCE_PATH; if [ ! "$SOURCE_PATH" ]; then SOURCE_PATH="./"; fi
  
  echo
  while [ ! "$TARGET_PATH" ]
  do
    echo "=== to target [remote:path]"
    read -p ">>> " TARGET_PATH
  done

  #  read -p "rclone $RC_CMD  with max-age >>> " MAX_AGE ## 发现用了 max-age 并没有提升速度，反而略有下降，即使对大量现有文件和少量更新文件

  echo
  echo "excluding files and folders (folders must end with /)"
  read -p ">>> " EXCLUDING;
  
  echo 
  echo "with [number] files in parallel, default 4"
  read -p ">>> " TRANSFERS;
  if [ ! "$TRANSFERS" ]; then TRANSFERS=4; fi


  echo
  echo "with [number] threads simultaneously, default 4"; 
  read -p ">>> " THREADS;
  if [ ! "$THREADS" ]; then THREADS=4; fi

  FULL_CMD="rclone $RC_CMD $SOURCE_PATH $TARGET_PATH -P -L --transfers=$TRANSFERS --multi-thread-streams=$THREADS --create-empty-src-dirs --exclude=._* --exclude=.DS_Store --exclude={node_modules/,.deploy_git/,unpackage/,$EXCLUDING}"

  echo
  echo "*****************************"
  echo $FULL_CMD
  echo "*****************************"
  echo
  echo "Starting? [y] for yes, [anything else] for quit"
  read -p ">>> " YES_OR_NOT
  echo
  if [ "$YES_OR_NOT" = 'y' ]
  then
    echo "****************** [rclone $RC_CMD] Start: `date -u -Iseconds` *****************"
    $FULL_CMD
    echo "****************** [rclone $RC_CMD] Start: `date -u -Iseconds` *****************"
    echo
    rclone ls $TARGET_PATH
  fi
elif [ "ACTION_TYPE" = 'w' ]
then
  rclone rcd --rc-web-gui
fi
