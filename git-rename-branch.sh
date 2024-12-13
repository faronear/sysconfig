#!/bin/bash

if [ -d "$1" ]
then
  ROOTPATH=$1
else
  echo ""
  echo "#<<< Enter [root path] or [leave blank] for default to [[`pwd`]]"
  read -p "#>>> " ROOTPATH
  if [ "$ROOTPATH"]
  then
    ROOTPATH=`realpath $ROOTPATH`
  else
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

echo "#<<< Enter [y] to start updating, or [anything else] to quit"
read -p "#>>> " YESNO
if [ "$YESNO" != 'y' ]
then
  exit
fi

pushd $ROOTPATH
echo "*** Starting from [[`pwd`]] ***"
echo ""

# for org in `ls -F | grep '/$' | grep -v '~'` ## 首先过滤出所有子目录，然后过滤出所有不含 ~ 的子目录。注意 for ??? in `ls ???` 是按照空行以及空格进行分割的，因此最后筛选出的目录名不能含有空格，否则就被分割成多个了。
ls -F | grep '/$' | grep -v '=' | while read org ## 换用这种方法，可以成功过滤出含有空格的完整目录名
do 
  echo "#<<<===== entering [[$ROOTPATH/$org]]"
  echo ""
  cd "$org";
  for repo in * ## for ??? in * 是分割成一个个目录名的，即使目录名含有空格
  do
    if [ -d "$repo/.git" ]
    then
      cd "$repo"
      # echo "    changing repo url to [[$ROOTPATH/$org/$repo]]"
      # git remote remove origin
      # git remote add origin https://git.faronear.org/$org/$repo
      # git pull
      # git branch --set-upstream-to=origin/main main
      # git pull
      echo "---- renaming branch master to main for [[`pwd`/$repo]] ----"
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
