#!/bin/bash

FONPATH1=/faronear
FONPATH2=~/faronear.git
FONPATH3=~/faronear
FONPATH4=/mnt/d/faronear

if [ "$1" ]
then
  FONPATH=$1
elif [ -d $FONPATH1 ]
then 
  FONPATH=$FONPATH1
elif [ -d $FONPATH2 ]
then
  FONPATH=$FONPATH2
elif [ -d $FONPATH3 ]
then
  FONPATH=$FONPATH3
elif [ -d $FONPATH4 ]
then
  FONPATH=$FONPATH4

else
  echo "=== Enter [target path] or leave [blank] for default to '.'"
  read -p ">>> " FONPATH
  echo ""
  if [ ! "$FONPATH" ]
  then
    FONPATH=.
  fi
fi

if [ ! -d "$FONPATH" ]
then 
  echo "*** [$FONPATH] not exist! Exit now. ***"
  exit
fi

pushd $FONPATH
echo "*** Current path = [`pwd`] ***"
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
      cd "$repo"
      # echo "    changing repo url to [$FONPATH/$org/$repo]"
      # git remote remove origin
      # git remote add origin https://git.faronear.org/$org/$repo
      # git pull
      # git branch --set-upstream-to=origin/main main
      # git pull
      echo "---- renaming branch master to main for [`pwd`/$repo] ----"
      git branch -m master main
      git push -u origin main
      git push origin :master
      echo ""
      cd ..
    fi
  done
  cd ..
done
popd
