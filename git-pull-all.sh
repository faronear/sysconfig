#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  if [ -d /faronear ]
  then 
    FONPATH=/faronear
  else
    if [ -d ~/faronear ]
    then
      FONPATH=~/faronear
    else
      echo "=== Enter [faronear root path] or leave blank for default to [.]"
      read -p ">>> " FONPATH
      echo ""
      if [ ! $FONPATH ]
      then
        FONPATH=.
      fi
    fi
  fi
fi

if [ ! -d $FONPATH ]
then 
  echo "*** [$FONPATH] not exist! Exit now. ***"
  exit
fi

pushd $FONPATH
echo "*** FONPATH = [`pwd`] ***"
echo ""

# for org in `ls -F | grep '/$' | grep -v '~'` ## 首先过滤出所有子目录，然后过滤出所有不含 ~ 的子目录。注意 for ??? in `ls ???` 是按照空行以及空格进行分割的，因此最后筛选出的目录名不能含有空格，否则就被分割成多个了。
ls -F | grep '/$' | grep -v '=' | while read org ## 换用这种方法，可以成功过滤出含有空格的完整目录名
do 
  echo "======== entering [$FONPATH/$org] ========"
  echo ""
  cd "$org";
  for repo in * ## for ??? in * 是分割成一个个目录名的，即使目录名含有空格
  do
    if [ -d "$repo/.git" ]
    then
      echo "---- git pulling [`pwd`/$repo] ----"
      cd "$repo"
      git pull --all
      echo ""
      cd ..
    fi
  done
  cd ..
done
popd
