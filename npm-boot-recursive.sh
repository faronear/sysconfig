#!/bin/bash

testpath1=/faronear
testpath2=~/faronear.git
testpath3=~/faronear
testpath4=/mnt/d/faronear

if [ "$1" ]
then
  FONPATH=$1
elif [ -d $testpath1 ]
then 
  FONPATH=$testpath1
elif [ -d $testpath2 ]
then
  FONPATH=$testpath2
elif [ -d $testpath3 ]
then
  FONPATH=$testpath3
elif [ -d $testpath4 ]
then
  FONPATH=$testpath4
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
echo "*** Starting from [`pwd`] ***"
echo ""

find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl' | while read repo
do 
  if ( [ -f "$repo/package.json" ] && grep -q '"boot"' "$repo/package.json" )
  then
    echo ""
    echo "---- npm booting: [$repo] ----"
    echo ""
    pushd "$repo"
    npm run boot
    echo ""
    echo "---- npm booted: [$repo] ----"
    echo ""
    popd
  fi
done
popd
