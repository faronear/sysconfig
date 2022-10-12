#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  echo "=== Enter [faronear root path] or leave blank for default to one of [/faronear], [~/faronear], [.]"
  read -p ">>> " FONPATH
  echo ""
fi

if [ ! $FONPATH ]
then
  if [ -d /faronear ]
  then 
    FONPATH=/faronear
  elif [ -d ~/faronear ]
  then
    FONPATH=~/faronear
  else
    FONPATH=.
  fi
elif [ ! -d $FONPATH ]
then 
  echo "*** [$FONPATH] not exist! Exit now. ***"
  exit
fi

pushd $FONPATH
echo "*** FONPATH = [`pwd`] ***"
# for org in `ls -F | grep '/$' | grep -v '~'` ## 首先过滤出所有子目录，然后过滤出所有不含 ~ 的子目录。注意 for ??? in `ls ???` 是按照空行以及空格进行分割的，因此最后筛选出的目录名不能含有空格，否则就被分割成多个了。
ls -F | grep '/$' | grep -v '=' | while read org ## 换用这种方法，可以成功过滤出含有空格的完整目录名
do 
  echo "======== entering [$FONPATH/$org] ========"
  echo ""
  cd "$org";
  for repo in * ## for ??? in * 是分割成一个个目录名的，即使目录名含有空格
  do
    if ( [ -f "$repo/package.json" ] && grep -q '"boot"' "$repo/package.json" )
    then
      echo "<<<< npm booting: [$org/$repo] <<<<"
      cd "$repo"
      npm run boot
      echo ">>>> npm bootted: [$org/$repo] >>>>"
      echo ""
      cd ..
    fi
  done
  cd ..;
done
popd
