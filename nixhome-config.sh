#!/bin/bash

if [ -d "$1" ]
then
  NIXHOME=$1
else if [ -d "`pwd`/nixhome" ]
then
  NIXHOME=`pwd`/nixhome
else
  echo ""
  echo "#<<< Enter [root path] or [leave blank] for default to [[`pwd`]]"
  read -p "#>>> " NIXHOME
  if [ ! "$NIXHOME" ]
  then
    NIXHOME=`pwd`
  fi
fi
if [ ! -e "$NIXHOME/.bashrc" ]
then 
  echo "××× [[$NIXHOME/.bashrc]] not exist! Exit now. ***"
  exit
else
  echo "√√√ NIXHOME = [[$NIXHOME]]"
fi
echo ""

# $2 应当为用户名
if [ "$2" == 'root' ]
then
  HomePath=/root
  TheUser=root
elif [ "$2" ]
then
  HomePath=/home/$2
  TheUser=$2
else
  # 可能是 root 或其他
  HomePath=~
  TheUser=`whoami`
fi

if [ -d "$HomePath" ]
then

  pushd $HomePath
  
  homescriptlist=".emacs .emacs.lisp .bashrc .bash_profile .gitignore.global.txt"
  echo
  echo "#<<< Copy or link scripts? [l] to link, [c] to copy, [g] to git import, [anything else] to omit:"
  read -p "#>>> " CopyOrLinkScripts
  if [ "$CopyOrLinkScripts" == 'l' ]
  then
    for homescript in $homescriptlist
    do
      if [ -e "$homescript" ] || [ -L "$homescript" ]
      then
        mv $homescript $homescript.backup-$(date -u +%Y%m%dT%H%M%Sutc)
      fi
      echo "--- Linking [[$NIXHOME/$homescript]] to [[$HomePath/$homescript]] ..."
      ln -s $NIXHOME/$homescript ./
    done
  elif [ "$CopyOrLinkScripts" == 'c' ]
  then
    for homescript in $homescriptlist
    do
      if [ -e "$homescript" ] || [ -L "$homescript" ]
      then
        mv $homescript $homescript.backup-$(date -u +%Y%m%dT%H%M%Sutc)
      fi
      echo "--- Copying [[$NIXHOME/$homescript]] to [[$HomePath/$homescript]] ..."
      cp -r $NIXHOME/$homescript ./
    done
  elif [ "$CopyOrLinkScripts" == 'g' ]
  then
    for homescript in $homescriptlist
    do
      if [ -e "$homescript" ] || [ -L "$homescript" ]
      then
        mv $homescript $homescript.backup-$(date -u +%Y%m%dT%H%M%Sutc)
      fi
      curl -sSLO https://git.faronear.org/npm/sysconfig/raw/branch/main/nixhome/$homescript
    done
  else
    echo '--- Home scripts not changed.'
  fi

  echo

  if [ "$(uname)" == "Darwin" ]
  then
    echo '--- No need to configure ./ssh/authorized_keys on Mac OS X. Exit now.'
  elif [ "$TheUser" != 'root' ]  # 仅允许 non-root 用户进行远程密钥登录
  then

    mkdir -p $HomePath/.ssh
    chmod 700 $HomePath/.ssh
    if [ "$2" ]
    then
      # 由 root 指定新用户而创建的配置文件的 owner 是 root，而不是新用户，导致新用户无法读取该文件而密钥登录失败，因此要重设 owner。
      chown $TheUser:$TheUser $HomePath/.ssh
    fi
    if [ -f "$HomePath/.ssh/authorized_keys" ] || [ -L "$HomePath/.ssh/authorized_keys" ]
    then
      mv $HomePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys.backup-$(date -u +%Y%m%dT%H%M%Sutc)
    fi

    echo "#<<< Append or link or omit [[$HomePath/.ssh/authorized_keys]] to config ssh server? [a] for append, [l] for link, [anything else] for omit:"
    read -p "#>>> " CopyOrLinkOrOmitAuthorizedKeys

    if [ "$CopyOrLinkOrOmitAuthorizedKeys" = 'l' ]
    then
      echo "--- Linking [[$NIXHOME/authorized_keys]] to [[$HomePath/.ssh/authorized_keys]] ..."
      ln -s $NIXHOME/.ssh/authorized_keys $HomePath/.ssh/authorized_keys
      sudo chmod 644 $HomePath/.ssh/authorized_keys # 确保其他用户能读取 nixhome/.ssh/authorized_keys
    elif [ "$CopyOrLinkOrOmitAuthorizedKeys" = 'a' ]
    then
      echo "--- Copying [[$NIXHOME/authorized_keys]] to [[$HomePath/.ssh/authorized_keys]] ..."
      cat $NIXHOME/.ssh/authorized_keys >> $HomePath/.ssh/authorized_keys
      chmod 600 $HomePath/.ssh/authorized_keys
    fi
    echo

  fi

  popd
  
else
  echo "!!! Not found [[$HomePath]], please try again."
fi
