#!/bin/bash

echo "---------------------------------------------"
echo "User Name (leave blank for no change as $(git config --get user.name)" 
read -p "***:: " UserName
if [ $UserName ]
then
  echo "git config --global user.name $UserName"
  git config --global user.name $UserName
fi

echo "---------------------------------------------"
echo "User Email (leave blank for no change as $(git config --get user.email))" 
read -p "***:: " UserEmail
if [ $UserEmail ]
then
  echo "git config --global user.email $UserEmail"
  git config --global user.email $UserEmail
fi

echo "---------------------------------------------"
echo "如果 git 远程服务器的 ssl 证书过期，或者使用了自颁发的证书，连接时会出现验证错误 Cannot verify local issuer"
echo "Verify ssl? (true or false, blank for no change as $(git config --get http.sslVerify))" 
read -p "***:: " HttpSslVerify
if [ $HttpSslVerify ]
then
  echo "git config --global http.sslVerify $HttpSslVerify"
  git config --global http.sslVerify $HttpSslVerify
fi

echo "---------------------------------------------"
echo "Store credential in cache or store? (leave blank for no change as $(git config --get credential.helper))" 
read -p "***:: " CredentialHelper
if [ $CredentialHelper ]
then
  echo "git config --global credential.helper $CredentialHelper"
  git config --global credential.helper $CredentialHelper
fi

echo "---------------------------------------------"
echo "Store pull rebase to true or false? (leave blank for no change as $(git config --get pull.rebase))" 
read -p "***:: " PullRebase
if [ $PullRebase ]
then
  echo "git config --global pull.rebase $PullRebase"
  git config --global pull.rebase $PullRebase
fi

echo "---------------------------------------------"
echo "Set [path to global gitignore file] (leave blank for no change as $(git config --get core.excludesfile))"
read -p "***:: " ExcludesFile
if [ $ExcludesFile ]
then
  echo "git config --global core.excludesfile $ExcludesFile"
  git config --global core.excludesfile $ExcludesFile
else
  echo "File not exsit: $ExcludesFile"
fi

echo "---------------------------------------------"
echo "Set default branch since git 2.28 to master or main? (leave blank for no change as $(git config --get init.defaultbranch))"
read -p "***:: " DefaultBranch
if [ $DefaultBranch ]
then
  echo "git config --global init.defaultbranch $DefaultBranch"
  git config --global init.defaultbranch $DefaultBranch
fi

echo "---------------------------------------------"
echo "Set postBuffer size? Suggesting 157286400 (leave blank for no change as $(git config --get http.postBuffer))"
read -p "***:: " PostBufferSize
if [ $PostBufferSize ]
then
  echo "git config --global http.postBuffer $PostBufferSize"
  git config --global http.postBuffer $PostBufferSize
fi


