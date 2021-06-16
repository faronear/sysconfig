#!/bin/bash

echo "Usage: setup.sh [nodeVersion]"
echo "Example: setup.sh 14"

if [ v$1 != v ]
then
  nodeVersion=$1
else
  read -p "Enter node version (leave blank for default 14; 'nvm' for nvm) >> " nodeVersion
  if [ ! $nodeVersion ]
  then
    echo Use default node version 14
    nodeVersion=14
  fi
fi

if [ $nodeVersion == 'nvm' ]
then
  echo "######## Installing nvm ############################"
else
  sudo apt update
  echo "######## Installing C++ build tools for Linux ########"
  sudo apt install curl gcc g++ make -y

  echo "######## Installing node v$nodeVersion ########"
  echo From https://deb.nodesource.com/setup_$nodeVersion.x
  curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash - && sudo apt install nodejs -y
  echo "######## node v$nodeVersion installed completely! ##################"
fi
