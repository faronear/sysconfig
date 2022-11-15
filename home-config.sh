#!/bin/bash

testpath1=/faronear/fon/sysconfig/nixhome
testpath2=~/faronear/fon/sysconfig/nixhome
testpath3=~/faronear/fon/sysconfig.git/nixhome
testpath4=`pwd`/nixhome

if [ "$1" ]
then
  SourcePath=$1
elif [ -d $testpath1 ]
then 
  SourcePath=$testpath1
elif [ -d $testpath2 ]
then
  SourcePath=$testpath2
elif [ -d $testpath3 ]
then
  SourcePath=$testpath3
elif [ -d $testpath4 ]
then
  SourcePath=$testpath4
else
  echo "=== Enter [target path] or leave [blank] to exit"
  read -p ">>> " SourcePath
  echo ""
  if [ ! -d "$SourcePath" ]
  then 
    echo "*** Source path [$SourcePath] not available! Exit now. ***"
    exit
  fi
fi


if [ "$2" ]
then
  HomePath=/home/$2
else
  HomePath=~
fi

if [ -d $HomePath ]
then
  pushd $HomePath
  homescriptlist=".emacs .emacs.lisp .bashrc .bash_profile .gitignore"
  echo
  echo "=== Copy or link scripts? <l> for link, <<anything else>> for copy:"
  read -p ">>> " CopyOrLinkScripts
  for homescript in $homescriptlist
  do
    mv $homescript $homescript.backup-$(date +%Y%m%d%H%M%S)
    if [ "$CopyOrLinkScripts" = 'l' ]
    then
      echo "--- Linking $SourcePath/$homescript to $HomePath/$homescript ..."
      ln -s $SourcePath/$homescript ./
    else
      echo "--- Copying $SourcePath/$homescript to $HomePath/$homescript ..."
      cp -r $SourcePath/$homescript ./
    fi
  done
  echo
  echo "=== Append or link or omit [.ssh/authorized_keys] to config ssh server? <a> for append, <l> for link, <<anything else>> for omit:"
  read -p ">>> " CopyOrLinkOrOmitAuthorizedKeys
  if [ "$CopyOrLinkOrOmitAuthorizedKeys" = 'l' ]
  then
    echo "--- Linking $SourcePath/authorized_keys to $HomePath/.ssh/authorized_keys ..."
    mkdir -p $HomePath/.ssh
    chmod 700 $HomePath/.ssh
    chown adot:adot .ssh
    mv $HomePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys.backup-$(date +%Y%m%d%H%M%S)
    ln -s $SourcePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys
  elif [ "$CopyOrLinkOrOmitAuthorizedKeys" = 'a' ]
  then
    mkdir -p $HomePath/.ssh
    chmod 700 $HomePath/.ssh
    if [ "$2" ]
    then
      chown $2:$2 $HomePath
    fi
    if [ -L '$HomePath/.ssh/authorized_keys' ]
    then
      mv $HomePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys.backup
    fi
    cat $SourcePath/.ssh/authorized_keys >> $HomePath/.ssh/authorized_keys
    chmod 600 $HomePath/.ssh/authorized_keys
  fi
  echo
  popd
else
  echo "!!! Not existing $HomePath, please try again."
fi

echo "=== Sourcing $HomePath/.bashrc ..."
source $HomePath/.bashrc
