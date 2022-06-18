#!/bin/bash

if [ $1 ]
then
  SourcePath=$1
else
  echo "Configure private home settings"
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

if [ -d $SourcePath ] && [ -d $HomePath ]
then
  pushd $HomePath
  homescriptlist=".emacs .emacs.lisp .bashrc .bash_profile .gitignore"
  for homescript in $homescriptlist
  do
    echo "--- Copying $SourcePath/$homescript to $HomePath/$homescript ..."
    rm -fr $homescript.backup
    mv $homescript $homescript.backup
    cp -r $SourcePath/$homescript $HomePath
  done
  read -p "Linking .ssh/authorized_keys? Enter l to link or anything else to ignore >> " linkSshKeys
  if [ $linkSshKeys == "l" ]
  then
    echo "--- Linking $SourcePath/authorized_keys to $HomePath/.ssh/authorized_keys ..."
    mkdir -p $HomePath/.ssh
    chmod 700 $HomePath/.ssh
    if [ -e $HomePath/.ssh/authorized_keys ]
    then
      rm -fr $HomePath/.ssh/authorized_keys.backup
      mv $HomePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys.backup
    fi
    ln -s $SourcePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys
  fi
  popd
else
  echo "!!! Not existing $SourcePath or $HomePath, please try again."
fi

echo "--- Sourcing $HomePath/.bashrc ..."
source $HomePath/.bashrc
