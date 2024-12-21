#!/bin/bash

echo "---------------------------------------------"
echo "User Name (leave blank for no change)" 
read -p "***:: " UserName
if [ $UserName ]
then
  echo "git config --global user.name $UserName"
  git config --global user.name $UserName
fi

echo "---------------------------------------------"
echo "User Email (leave blank for no change)" 
read -p "***:: " UserEmail
if [ $UserEmail ]
then
  echo "git config --global user.email $UserEmail"
  git config --global user.email $UserEmail
fi

echo "---------------------------------------------"
echo "如果 git 远程服务器的 ssl 证书过期，或者使用了自颁发的证书，连接时会出现验证错误 Cannot verify local issuer"
echo "Verify ssl? (true or false, blank for no change)" 
read -p "***:: " HttpSslVerify
if [ $HttpSslVerify ]
then
  echo "git config --global http.sslVerify $HttpSslVerify"
  git config --global http.sslVerify $HttpSslVerify
fi

echo "---------------------------------------------"
echo "Store credential in cache or store? (leave blank for no change)" 
read -p "***:: " CredentialHelper
if [ $CredentialHelper ]
then
  echo "git config --global credential.helper $CredentialHelper"
  git config --global credential.helper $CredentialHelper
fi

echo "---------------------------------------------"
echo "Store pull rebase to true or false? (leave blank for no change)" 
read -p "***:: " PullRebase
if [ $PullRebase ]
then
  echo "git config --global pull.rebase $PullRebase"
  git config --global pull.rebase $PullRebase
fi

echo "---------------------------------------------"
echo "Path to global gitignore file? (For example ~/.gitignore.global.txt, leave blank for no change)"
read -p "***:: " ExcludesFile
if [ $ExcludesFile ]
then
  echo "git config --global core.excludesfile $ExcludesFile"
  git config --global core.excludesfile $ExcludesFile
else
  echo "File not exsit: $ExcludesFile"
fi

echo "---------------------------------------------"
echo "Set default branch since git 2.28 to master or main? (leave blank for no change)"
read -p "***:: " DefaultBranch
if [ $DefaultBranch ]
then
  echo "git config --global init.defaultbranch $DefaultBranch"
  git config --global init.defaultbranch $DefaultBranch
fi
