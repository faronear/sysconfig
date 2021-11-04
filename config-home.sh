#!/bin/bash

if [ $1 ]
then
  SourcePath=$1
else
  echo "Usage: setup.sh [Config-Source-Path] [User-Home-Path]"
  echo "---------------------------------------------"
  read -p "Enter config source path (leave blank for [Users/luk.lu]/faronear/fon/sysconfig/home) >> " SourcePath
  if [ ! $SourcePath ]
  then
    echo "Use default source path: [Users/luk.lu]/faronear/fon/sysconfig/home"
    if [ -d /faronear/fon/sysconfig/home ]
    then 
      SourcePath=/faronear/fon/sysconfig/home
    else
      if [ -d /Users/luk.lu/faronear/fon/sysconfig/home ]
      then
        SourcePath=/Users/luk.lu/faronear/fon/sysconfig/home
      else
        SourcePath=`pwd`/home
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
echo My Home Path ========= $HomePath

if [ ! -d $SourcePath ]
then
  echo "!!! Not existing $SourcePath, please try again"
else
  echo "Copy home scripts from $SourcePath"
  pushd $HomePath
  echo "---------------------------------------------"
  homescriptlist=".emacs .emacs.lisp .bashrc .bash_profile .gitignore"
  for homescript in $homescriptlist
  do
    if [ -f $homescript ]
    then
      mv $homescript $homescript.backup
    fi
    ln -s $SourcePath/$homescript $HomePath
    echo Linked $HomePath/$homescript to $SourcePath/$homescript
  done
  echo "---------------------------------------------"
  source ~/.bashrc
  popd
  echo "^_^ Home Setting Complete"
fi