#!/bin/bash

echo "Usage: setup.sh [Source-Path-To-Config-Files]"
echo "---------------------------------------------"

if [ $1 ]
then
  SourcePath=$1
else
  read -p "Enter config source path (leave blank for /faronear/lib/sysconfig) >> " SourcePath
  if [ ! $SourcePath ]
  then
    echo Use default source path: /faronear/lib/sysconfig
    SourcePath=/faronear/lib/sysconfig
  fi
fi

if [ ! -d $SourcePath ]
then
  echo !!! Not existing $SourcePath, please try again
else
  echo "Config home from $SourcePath"
  if [ -e ~/.emacs ]
  then
    mv ~/.emacs ~/.emacs.backup
  fi
  rm -fr ~/.emacs
  ln -s $SourcePath/.emacs ~/

  if [ -e ~/.emacs.lisp ]
  then
    mv ~/.emacs.lisp ~/.emacs.lisp.backup
  fi
  rm -fr ~/.emacs.lisp
  ln -s $SourcePath/.emacs.lisp ~/

  if [ -e ~/.bashrc ]
  then
    mv ~/.bashrc ~/.bashrc.backup
  fi
  rm -fr ~/.bashrc
  ln -s $SourcePath/.bashrc ~/

  if [ -e ~/.bash_profile ]
  then
    mv ~/.bash_profile ~/.bash_profile.backup
  fi
  rm -fr ~/.bash_profile
  ln -s $SourcePath/.bash_profile ~/

  . ~/.bashrc

  echo "^_^ Home Setting Complete"
fi