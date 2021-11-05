#!/bin/bash

echo "Usage: setup.sh [nodeVersion]"

defaultVersion=16

if [ v$1 != v ]
then
  nodeVersion=$1
else
  read -p "Enter nodejs version (leave blank for default 16; 'nvm' for nvm) >> " nodeVersion
  if [ ! $nodeVersion ]
  then
    nodeVersion=$defaultVersion
    echo Use default node version $nodeVersion
  fi
fi

if [ $nodeVersion == 'nvm' ]
then
  echo "######## Installing nvm ############################"
else
  sudo apt update
  echo "######## Installing C++ build tools for Linux ########"
  sudo apt install curl gcc g++ make -y

  echo "######## Installing nodejs v$nodeVersion ########"
  echo From https://deb.nodesource.com/setup_$nodeVersion.x
  curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash - && sudo apt install nodejs -y
  echo "######## nodejs v$nodeVersion installed completely! ##################"
fi
