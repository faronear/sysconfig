#!/bin/bash

testpath0=/faronear/sysconfig/nixhome
testpath1=/faronear/fon/sysconfig/nixhome
testpath2=~/faronear/fon/sysconfig/nixhome
testpath3=~/faronear/fon.git/sysconfig/nixhome
testpath4=~/faronear.git/fon.git/sysconfig/nixhome
testpath5=`pwd`/nixhome

if [ "$1" ]
then
  SourcePath=$0
elif [ -d $testpath0 ]
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
elif [ -d $testpath5 ]
then
  SourcePath=$testpath5
else
  echo "=== Enter [nixhome path] or leave [blank] to exit"
  read -p ">>> " SourcePath
  echo ""
  if [ ! -d "$SourcePath" ]
  then 
    echo "*** nixhome path [$SourcePath] not available! Exit now. ***"
    exit
  fi
fi

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
  
  homescriptlist=".emacs .emacs.lisp .bashrc .bash_profile .gitignore"
  echo
  echo "=== Copy or link scripts? <l> to link, <c> to copy, <anything else> to omit:"
  read -p ">>> " CopyOrLinkScripts
  if [ "$CopyOrLinkScripts" == 'l' ]
  then
    for homescript in $homescriptlist
    do
      if [ -e "$homescript" ] || [ -L "$homescript" ]
      then
        mv $homescript $homescript.backup-$(date +%Y%m%dT%H%M%S)
      fi
      echo "--- Linking $SourcePath/$homescript to $HomePath/$homescript ..."
      ln -s $SourcePath/$homescript ./
    done
  elif [ "$CopyOrLinkScripts" == 'c' ]
  then
    for homescript in $homescriptlist
    do
      if [ -e "$homescript" ]
      then
        mv $homescript $homescript.backup-$(date +%Y%m%dT%H%M%S)
      fi
      echo "--- Copying $SourcePath/$homescript to $HomePath/$homescript ..."
      cp -r $SourcePath/$homescript ./
    done
  else
    echo '--- Home scripts not changed.'
  fi

  echo

  if [ "$TheUser" != 'root' ] && [[ "$(uname)" != "Darwin" ]] # 仅允许 non-root 用户进行远程密钥登录
  then

    mkdir -p $HomePath/.ssh
    chmod 700 $HomePath/.ssh
    if [ "$2" ]
    then
      # 由 root 指定新用户而创建的配置文件的 owner 是 root，而不是新用户，导致新用户无法读取该文件而密钥登录失败，因此要重设 owner。
      chown $TheUser:$TheUser $HomePath/.ssh
    fi
    if [ -e '$HomePath/.ssh/authorized_keys' ]
    then
      mv $HomePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys.backup-$(date +%Y%m%dT%H%M%S)
    fi

    echo "=== Append or link or omit [$HomePath/.ssh/authorized_keys] to config ssh server? <a> for append, <l> for link, <<anything else>> for omit:"
    read -p ">>> " CopyOrLinkOrOmitAuthorizedKeys

    if [ "$CopyOrLinkOrOmitAuthorizedKeys" = 'l' ]
    then
      echo "--- Linking $SourcePath/authorized_keys to $HomePath/.ssh/authorized_keys ..."
      ln -s $SourcePath/.ssh/authorized_keys $HomePath/.ssh/authorized_keys
      sudo chmod 644 $HomePath/.ssh/authorized_keys # 确保其他用户能读取 nixhome/.ssh/authorized_keys
    elif [ "$CopyOrLinkOrOmitAuthorizedKeys" = 'a' ]
    then
      echo "--- Copying $SourcePath/authorized_keys to $HomePath/.ssh/authorized_keys ..."
      cat $SourcePath/.ssh/authorized_keys >> $HomePath/.ssh/authorized_keys
      chmod 600 $HomePath/.ssh/authorized_keys
    fi
    echo

  fi

  popd
  
else
  echo "!!! Not existing $HomePath, please try again."
fi
