#!/bin/bash

echo "Usage: this-script.sh [nodeVersion]"

defaultVersion=16

if [ $1 ]
then
  nodeVersion=$1
else
  read -p "Enter nodejs version (leave blank for default $defaultVersion) or 'tools' >> " nodeVersion
  if [ ! $nodeVersion ]
  then
    nodeVersion=$defaultVersion
    echo Use default nodejs version $defaultVersion
  fi
fi

sudo apt update

if [ $nodeVersion != "tools" ]
then
  echo "######## Installing nodejs v$nodeVersion ########"
  curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash - && sudo apt install nodejs -y
  # for centos: curl --silent --location https://rpm.nodesource.com/setup_$nodeVersion.x | sudo bash
  echo "######## nodejs v$nodeVersion installed completely! ########"
fi

echo "######## Installing C++ build tools for Linux ########"
sudo apt install wget curl gcc g++ make python -y # Debian 11 has no python by default.
