#!/bin/bash

echo "Usage: this-script.sh [VERSION]"

defaultVERSION=18.12.1

if [ $1 ]
then
  VERSION=$1
else
  echo "=== Enter [nodejs version] or [leave blank] for default $defaultVERSION, enter [tools] to install C++ build tools" 
  read -p ">>> " VERSION
  if [ ! $VERSION ]
  then
    VERSION=$defaultVERSION
    echo Use default nodejs version $defaultVERSION
  fi
fi

sudo apt update

if [ $VERSION != "tools" ]
then
  echo "######## Installing nodejs v$VERSION ########"
  curl -sL https://deb.nodesource.com/setup_$VERSION.x | sudo bash - && sudo apt install nodejs -y
  # for centos: curl --silent --location https://rpm.nodesource.com/setup_$VERSION.x | sudo bash
  echo "######## nodejs v$VERSION installed completely! ########"
fi

echo "######## Installing C++ build tools for Linux ########"
sudo apt install wget curl gcc g++ make python -y # Debian 11 has no python by default.
