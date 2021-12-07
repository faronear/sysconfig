#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  echo Leave blank for default [/faronear], [~/faronear], [../..],
  read -p "or enter faronear path to git pull >> " FONPATH
  if [ ! $FONPATH ]
  then
    if [ -d /faronear ]
    then 
      FONPATH=/faronear
    else
      if [ -d ~/faronear ]
      then
        FONPATH=~/faronear
      else
        FONPATH=../..
      fi
    fi
  fi
fi

if [ ! -d $FONPATH ]
then 
  echo "*** [$FONPATH] not exist! Exit now. ***"
  exit
fi

pushd $FONPATH
echo "*** Current path = [`pwd`] ***"
echo ""

for org in `ls | grep -v ~cloud`
do 
  if [ -d $org ]
  then
    echo "entering [$FONPATH/$org]"
    echo ""
    cd $org;
    for repo in `ls .`
    do
      if [ -d $repo/.git ]
      then
        echo "git pulling [$FONPATH/$org/$repo]"
        cd $repo
        git pull
        echo ""
        cd ..
      fi
    done
    cd ..
  fi
done
popd
