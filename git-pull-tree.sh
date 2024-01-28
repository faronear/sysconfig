#!/bin/bash

if [ -d "$1" ]
then
  ROOTPATH=$1
else
  echo ""
  echo "=== Enter [start path] or [leave blank] for default to [[`pwd`]]"
  read -p ">>> " ROOTPATH
  echo ""
  if [ ! "$ROOTPATH" ]
  then
    ROOTPATH=`pwd`
  fi
fi

if [ ! -d "$ROOTPATH" ]
then 
  echo "××× [[$ROOTPATH]] not exist! Exit now. ***"
  exit
else
  echo "√√√ ROOTPATH = [[$ROOTPATH]]"
fi

pushd $ROOTPATH
echo "*** Starting from [[`pwd`]] ***"
echo ""

if [ "$2" == 'hier' ]
then
  # for org in `ls -F | grep '/$' | grep -v '~'` ## 首先过滤出所有子目录，然后过滤出所有不含 ~ 的子目录。注意 for ??? in `ls ???` 是按照空行以及空格进行分割的，因此最后筛选出的目录名不能含有空格，否则就被分割成多个了。
  ls -F | grep '/$' | grep -v 'node_modules' | while read org ## 换用这种方法，可以成功过滤出含有空格的完整目录名
  do 
    echo "======== entering [[$ROOTPATH/$org]] ========"
    echo ""
    cd "$org";
    for repo in * ## for ??? in * 是分割成一个个目录名的，即使目录名含有空格
    do
      if [ -d "$repo/.git" ]
      then
        echo "---- git pulling [[`pwd`/$repo]] ----"
        cd "$repo"
        git pull --all
        echo ""
        cd ..
      fi
    done
    cd ..
  done
else
  find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl' | while read repo
  do 
    if [ -d "$repo/.git" ]
    then
      echo "---- git pulling [[$repo]] ----"
      pushd "$repo"
      git pull --all
      echo ""
      popd
    fi
  done
fi

popd
