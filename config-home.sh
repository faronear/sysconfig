#!/bin/bash

echo "Usage: setup.sh [Source-Path-To-Config-Files]"
echo "---------------------------------------------"

if [ $1 ]
then
  SourcePath=$1
else
  read -p "Enter config source path (leave blank for /faronear/lib/sysconfig/home) >> " SourcePath
  if [ ! $SourcePath ]
  then
    echo "Use default source path: /faronear/lib/sysconfig/home"
    SourcePath=/faronear/lib/sysconfig/home
  fi
fi

if [ ! -d $SourcePath ]
then
  echo "!!! Not existing $SourcePath, please try again"
else
  echo "Config home from $SourcePath"

  echo "---------------------------------------------"
  if [ -e ~/.emacs ]
  then
    mv ~/.emacs ~/.emacs.backup
  fi
  rm -fr ~/.emacs
  ln -s $SourcePath/.emacs ~/
  echo Linked ~/.emacs to $SourcePath/.emacs

  echo "---------------------------------------------"
  if [ -e ~/.emacs.lisp ]
  then
    mv ~/.emacs.lisp ~/.emacs.lisp.backup
  fi
  rm -fr ~/.emacs.lisp
  ln -s $SourcePath/.emacs.lisp ~/
  echo Linked ~/.emacs.lisp to $SourcePath/.emacs.lisp

  echo "---------------------------------------------"
  if [ -e ~/.bashrc ]
  then
    mv ~/.bashrc ~/.bashrc.backup
  fi
  rm -fr ~/.bashrc
  ln -s $SourcePath/.bashrc ~/
  echo Linked ~/.bashrc to $SourcePath/.bashrc

  echo "---------------------------------------------"
  if [ -e ~/.bash_profile ]
  then
    mv ~/.bash_profile ~/.bash_profile.backup
  fi
  rm -fr ~/.bash_profile
  ln -s $SourcePath/.bash_profile ~/
  echo Linked ~/.bash_profile to $SourcePath/.bash_profile

  echo "---------------------------------------------"
  if [ -e ~/.gitignore ]
  then
    mv ~/.gitignore ~/.gitignore.backup
  fi
  rm -fr ~/.gitignore
  ln -s $SourcePath/.gitignore ~/
  echo Linked ~/.gitignore to $SourcePath/.gitignore

  echo "---------------------------------------------"
  echo Executing ~/.bashrc
  . ~/.bashrc

  echo "^_^ Home Setting Complete"
fi