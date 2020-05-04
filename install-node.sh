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
  echo "######## 安装 nvm ############################"
else
  sudo apt update
  sudo apt install curl gcc g++ make -y

  echo "######## 安装 node v$nodeVersion ##################"
  echo https://deb.nodesource.com/setup_$nodeVersion.x
  curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash - && sudo apt install nodejs -y
  echo "######## node v$nodeVersion 安装完毕！##################"
fi
