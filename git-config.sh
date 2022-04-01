#!/bin/bash

echo "---------------------------------------------"
read -p "User Name to show in git log (leave blank for no change) >>> " UserName
if [ $UserName ]
then
  echo "git config --global user.name $UserName"
  git config --global user.name $UserName
fi

echo "---------------------------------------------"
read -p "User Email to show in git log (leave blank for no change) >>> " UserEmail
if [ $UserEmail ]
then
  echo "git config --global user.email $UserEmail"
  git config --global user.email $UserEmail
fi

echo "---------------------------------------------"
echo "如果 git 远程服务器的 ssl 证书过期，或者使用了自颁发的证书，连接时会出现验证错误 Cannot verify local issuer"
read -p "Force connect even if ssl failed verification? (true or false, blank for no change) >> " HttpSslVerify
if [ $HttpSslVerify ]
then
  echo "git config --global http.sslVerify $HttpSslVerify"
  git config --global http.sslVerify $HttpSslVerify
fi

echo "---------------------------------------------"
read -p "Store credential in cache or store? (leave blank for no change) >> " CredentialHelper
if [ $CredentialHelper ]
then
  echo "git config --global credential.helper $CredentialHelper"
  git config --global credential.helper $CredentialHelper
fi

echo "---------------------------------------------"
read -p "Path to global gitignore file? (For example ~/.gitignore, leave blank for no change) >> " ExcludesFile
if [ $ExcludesFile ]
then
  if [ -e $ExcludesFile ]
  then
    echo "git config --global core.excludesfile $ExcludesFile"
    git config --global core.excludesfile $ExcludesFile
  else
    echo "File not exsit: $ExcludesFile"
  fi
fi

echo "---------------------------------------------"
read -p "Set default branch since git 2.28 to master or main? (leave blank for no change) >> " DefaultBranch
if [ $DefaultBranch ]
then
  echo "git config --global init.defaultbranch $DefaultBranch"
  git config --global init.defaultbranch $DefaultBranch
fi