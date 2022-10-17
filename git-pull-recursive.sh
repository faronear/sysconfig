#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
elif [ -d /faronear ]
then 
  FONPATH=/faronear
elif [ -d ~/faronear ]
then
  FONPATH=~/faronear
elif [ -d /mnt/d/faronear ]
then
  FONPATH=/mnt/d/faronear
else
  echo "=== Enter [target path] or leave [blank] for default to `.`"
  read -p ">>> " FONPATH
  echo ""
  if [ ! $FONPATH ]
  then
    FONPATH=.
  fi
fi

if [ ! -d $FONPATH ]
then 
  echo "*** [$FONPATH] not exist! Exit now. ***"
  exit
fi

pushd $FONPATH
echo "*** Starting from [`pwd`] ***"
echo ""

find . -mindepth 1 -maxdepth 3 -type d -name '?*.git' | grep -v 'node_modules' | while read repo
do 
  if [ -d "$repo/.git" ]
  then
    echo "---- git pulling [`pwd`/$repo] ----"
    pushd "$repo"
    git pull --all
    echo ""
    popd
  fi
done
popd
