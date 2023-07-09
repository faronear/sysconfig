#!/bin/bash

if [ -d "$1" ]
then
  FONPATH=$1
else
  echo "××× All testing path failed."
  echo ""
  echo "=== Enter [fonpath] or leave [blank] for default to '.'"
  read -p ">>> " FONPATH
  echo ""
  if [ ! "$FONPATH" ]
  then
    FONPATH=.
  fi
fi

if [ ! -d "$FONPATH" ]
then 
  echo "××× [$FONPATH] not exist! Exit now. ***"
  exit
else
  echo "√√√ FONPATH = $FONPATH"
fi

cd $FONPATH
echo "*** Starting from [`pwd`] ***"
echo ""

echo "=== Enter [path-to-seafile-ignore.txt]"
read -p ">>> " SFIGNOREPATH
echo ""
if [ ! -f "$SFIGNOREPATH/seafile-ignore.txt" ]
then
  echo "××× Not existed [$SFIGNOREPATH/seafile-ignore.txt]. Exit now..."
  exit
fi

find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl' | while read repo
do 
  if [ -d "$repo/.git" ]
  then
    echo "---- updating seafile-ignore.txt in [$repo] ----"
    cp $SFIGNOREPATH/seafile-ignore.txt $repo/
    echo ""
  fi
done

cd -
