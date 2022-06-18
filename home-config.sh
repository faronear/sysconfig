#!/bin/bash

if [ $1 ]
then
  SourcePath=$1
else
  echo "Configure private home settings"
  echo "Usage: setup.sh [Config-Source-Path] [User-Home-Path] [--AdotMode]"
  echo
  echo "=== Enter config <<SourcePath>> or leave <<blank>> for [/Users/luk.lu]/faronear/fon/sysconfig/nixhome):" 
  read -p ">>> " SourcePath
  if [ ! $SourcePath ]
  then
    echo "Use default source path: [Users/luk.lu]/faronear/fon/sysconfig/nixhome"
    echo
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
  echo
  echo "=== Copy or link scripts? <l> for link, <<anything else>> for copy:"
  read -p ">>> " CopyOrLinkScripts
  for homescript in $homescriptlist
  do
    rm -fr $homescript.backup
    mv $homescript $homescript.backup
    if [ $CopyOrLinkScripts = 'l' ]
    then
      echo "--- Linking $SourcePath/$homescript to $HomePath/$homescript ..."
      ln -s $SourcePath/$homescript $HomePath
    else
      echo "--- Copying $SourcePath/$homescript to $HomePath/$homescript ..."
      cp -r $SourcePath/$homescript $HomePath
    fi
  done
  echo
  echo "=== Append or link or omit [.ssh/authorized_keys]? <a> for append, <l> for link, <<anything else>> for omit:"
  read -p ">>> " CopyOrLinkOrOmitAuthorizedKeys
  if [ $CopyOrLinkOrOmitAuthorizedKeys = 'l' ]
  then
    echo "--- Linking $SourcePath/authorized_keys to $HomePath/.ssh/authorized_keys ..."
    mkdir -p $HomePath/.ssh
    chmod 700 $HomePath/.ssh
    rm -fr $HomePath/.ssh/authorized_keys.backup
    mv $HomePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys.backup
    ln -s $SourcePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys
  elif [ $CopyOrLinkOrOmitAuthorizedKeys = 'a' ]
  then
    mkdir -p $HomePath/.ssh
    chmod 700 $HomePath/.ssh
    cat $SourcePath/.ssh/authorized_keys >> $HomePath/.ssh/authorized_keys
    chmod 600 $HomePath/.ssh/authorized_keys
  fi
  echo
  popd
else
  echo "!!! Not existing $SourcePath or $HomePath, please try again."
fi

echo "=== Sourcing $HomePath/.bashrc ..."
source $HomePath/.bashrc
