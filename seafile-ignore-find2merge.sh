#!/bin/bash

echo ""
echo "Search in [ROOTPATH], Merge [GLOBALPATH/seafile-ignore.global.txt] and [ROOTPATH/*/seafile-ignore.local.txt] files to [seafile-ignore.txt]"
echo ""

if [ -d "$1" ]
then
  ROOTPATH=$1
else
  echo "::*** Enter [root path] or [leave blank] for default [[`pwd`]] to start tree search for seafile-ignore.txt files"
  read -p "***:: " ROOTPATH
  if [ "$ROOTPATH" ]
  then
    ROOTPATH=$(realpath $ROOTPATH)
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
echo ""

echo "::*** Enter [path to seafile-ignore.global.txt] or [leave blank] for default [[https://git.tic.cc/open/sysconfig/raw/branch/main/nixhome/seafile-ignore.global.txt]]"
read -p "***:: " GLOBALPATH
if [ "$GLOBALPATH" ]
then
  if [ -d "$GLOBALPATH" ]
  then
    GLOBALPATH=$(realpath $GLOBALPATH)/seafile-ignore.global.txt
  fi
  if [ ! -f "$GLOBALPATH" ]
  then
    echo "××× Not found [[$GLOBALPATH]]. Exit now..."
    exit
  else
    echo "√√√ GLOBALPATH = [[$GLOBALPATH]]"
  fi
else
  GLOBALPATH=https://git.tic.cc/open/sysconfig/raw/branch/main/nixhome/seafile-ignore.global.txt
fi
echo ""

echo "::*** Enter [y] to start updating, or [anything else] to quit"
read -p "***:: " YESNO
if [ "$YESNO" != 'y' ]
then
  exit
fi

cd $ROOTPATH
echo "*** Starting from [[`pwd`]] ***"
echo ""

find . -mindepth 0 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules|uni_modules|\.deploy_git|\.git|.svn|\.vscode|\.wrangler|unpackage|_webroot|_logstore|_datasotre|_archive|_filestore|_ssl' | while read repo
do 
  if [ -f "$repo/seafile-ignore.txt" ] || [ -d "$repo/.git" ]
  then
    echo "---- updating [[$repo/seafile-ignore.txt]] ----"
    if [ -f "$GLOBALPATH" ]
    then
      cat $GLOBALPATH > $repo/seafile-ignore.txt
    else
      curl -sSL $GLOBALPATH | cat > $repo/seafile-ignore.txt
    fi
    cat $repo/seafile-ignore.local.txt 2>/dev/null >> $repo/seafile-ignore.txt
    echo ""
  fi
done

cd -
