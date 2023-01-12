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

pushd $FONPATH
echo "*** Starting from [`pwd`] ***"
echo ""

echo "=== Enter [commit message] or leave [blank] for default to 'updated'"
read -p ">>> " COMMIT_MESSAGE
if [ ! "$COMMIT_MESSAGE" ]
then
  COMMIT_MESSAGE="updated"
fi
echo ""

find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl' | while read repo
do 
  if [ -d "$repo/.git" ]
  then
    echo "---- git commit & push [$repo] ----"
    pushd "$repo"
    git add . && git commit -m "$COMMIT_MESSAGE" && git push
    echo ""
    popd
  fi
done
popd
