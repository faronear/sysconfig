#!/bin/bash

echo "Usage: setup.sh [nodeVersion]"
echo "Example: setup.sh 12"

if [ v$1 != v ]
then
  nodeVersion=$1
else
  read -p "Enter node version (leave blank for default 12) >> " nodeVersion
  if [ ! $nodeVersion ]
  then
    echo Use default node version 12
    nodeVersion=12
  fi
fi

sudo apt update
sudo apt install curl gcc g++ make -y

echo "######## 安装 node v$nodeVersion ##################"
echo https://deb.nodesource.com/setup_$nodeVersion.x
curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash - && sudo apt install nodejs -y
echo "######## node v$nodeVersion 安装完毕！##################"
