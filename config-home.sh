#!/bin/bash

if [ $1 ]
then
  SourcePath=$1
else
  echo "Usage: setup.sh [Config-Source-Path] [User-Home-Path]"
  read -p "Enter config source path (leave blank for [/Users/luk.lu]/faronear/fon/sysconfig/nixhome) >> " SourcePath
  if [ ! $SourcePath ]
  then
    echo "Use default source path: [Users/luk.lu]/faronear/fon/sysconfig/nixhome"
    if [ -d /faronear/fon/sysconfig/nixhome ]
    then 
      SourcePath=/faronear/fon/sysconfig/nixhome
    else
      if [ -d /Users/luk.lu/faronear/fon/sysconfig/nixhome ]
      then
        SourcePath=/Users/luk.lu/faronear/fon/sysconfig/nixhome
      else
        SourcePath=`pwd`/nixhome
      fi
    fi
  fi
fi

if [ $2 ]
then
  HomePath=$2
else
  HomePath=~
fi

if [ ! -d $SourcePath ]
then
  echo "!!! Not existing $SourcePath, please try again"
else
  echo "Linking $SourcePath/* to $HomePath/"
  pushd $HomePath
  homescriptlist=".emacs .emacs.lisp .bashrc .bash_profile .gitignore"
  for homescript in $homescriptlist
  do
    rm -fr $homescript.backup
    mv $homescript $homescript.backup
    ln -s $SourcePath/$homescript $HomePath
  done
  popd
  echo "Linked $SourcePath/* to $HomePath/"
fi

if [ ! -d $HomePath/.ssh]
then
  echo "Creating $HomePath/.ssh"
  mkdir $HomePath/.ssh
  chmod 700 $HomePath/.ssh
fi
if [ -f $Homepath/.ssh/authorized_keys ]
then
  echo "Removing $Homepath/.ssh/authorized_keys"
  mv $Homepath/.ssh/authorized_keys $Homepath/.ssh/authorized_keys.backup
fi
ln -s $SourcePath/authorized_keys $HomePath/.ssh/authorized_keys

echo "Applying $HomePath/.bashrc"
source $HomePath/.bashrc
