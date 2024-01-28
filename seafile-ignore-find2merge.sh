#!/bin/bash

echo ""
echo "Search in [ROOTPATH], Merge [IGNOREPATH/seafile-ignore_global] and [ROOTPATH/*/seafile-ignore_local] files to [seafile-ignore.txt]"
echo ""

if [ -d "$1" ]
then
  ROOTPATH=$1
else
  echo "=== Enter [root path] or [leave blank] for default [[`pwd`]] to start tree search for seafile-ignore.txt files"
  read -p ">>> " ROOTPATH
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

echo "=== Enter [path to seafile-ignore_global] or [leave blank] for default [[`pwd`]]"
read -p ">>> " IGNOREPATH
if [ "$IGNOREPATH" ]
then
  IGNOREPATH=$(realpath $IGNOREPATH)/seafile-ignore_global
else
  IGNOREPATH=`pwd`/seafile-ignore_global
fi
if [ ! -f "$IGNOREPATH" ]
then
  echo "××× Not found [[$IGNOREPATH]]. Exit now..."
  exit
else
  echo "√√√ IGNOREPATH = [[$IGNOREPATH]]"
fi
echo ""

echo "=== Enter [y] to start updating, or [anything else] to quit"
read -p ">>> " YESNO
if [ "$YESNO" != 'y' ]
then
  exit
fi

cd $ROOTPATH
echo "*** Starting from [[`pwd`]] ***"
echo ""

find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules|uni_modules|\.deploy_git|\.git|.svn|\.vscode|\.wrangler|unpackage|_webroot|_logstore|_datasotre|_archive|_filestore|_ssl' | while read repo
do 
  if [ -f "$repo/seafile-ignore.txt" ]
  then
    echo "---- updating seafile-ignore.txt in [[$repo]] ----"
    cat $IGNOREPATH $repo/seafile-ignore_local 2>/dev/null > $repo/seafile-ignore.txt
    echo ""
  fi
done

cd -
