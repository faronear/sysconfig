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

echo "=== Enter [path to seafile-ignore.txt]"
read -p ">>> " IGNOREPATH
echo ""
if [ ! -f "$IGNOREPATH/seafile-ignore.txt" ]
then
  echo "××× Not found [[$IGNOREPATH/seafile-ignore.txt]]. Exit now..."
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
    cp $IGNOREPATH/seafile-ignore.txt $repo/
    echo ""
  fi
done

cd -
