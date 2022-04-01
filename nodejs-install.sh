#!/bin/bash

echo "Usage: this-script.sh [nodeVersion]"

defaultVersion=16

if [ v$1 != v ]
then
  nodeVersion=$1
else
  read -p "Enter nodejs version (leave blank for default $defaultVersion) >> " nodeVersion
  if [ ! $nodeVersion ]
  then
    nodeVersion=$defaultVersion
    echo Use default node version $nodeVersion
  fi
fi

sudo apt update
echo "######## Installing C++ build tools for Linux ########"
sudo apt install curl gcc g++ make python -y # Debian 11 has no python by default.

echo "######## Installing nodejs v$nodeVersion ########"
echo From https://deb.nodesource.com/setup_$nodeVersion.x
curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash - && sudo apt install nodejs -y
echo "######## nodejs v$nodeVersion installed completely! ########"
