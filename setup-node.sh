#!/bin/bash

echo "Usage: setup.sh [VERSION]"
echo "Example: setup.sh 10"
echo "Run as root user please."

if [ v$1 != v ]
then
  export nodeVersion=$1
else
  export nodeVersion=10
fi

sudo apt update
sudo apt install curl gcc g++ make -y

echo "######## 安装 node v$nodeVersion ##################"
echo https://deb.nodesource.com/setup_$nodeVersion.x
curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash - && sudo apt install nodejs -y
echo "######## node v$nodeVersion 安装完毕！##################"
