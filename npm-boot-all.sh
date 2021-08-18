#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  echo Leave blank for default [/faronear], [~/faronear], [../..],
  read -p "or enter faronear path to npm run boot >> " FONPATH
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
for org in `ls | grep -v @cloud`
do 
  if [ -d $org ]
  then
    cd $org;
    for repo in `ls .`
    do
      if ( [ -f $repo/package.json ] && grep -q '"boot"' $repo/package.json )
      then
        echo '>>>>>> npm booting: ' $org/$repo
        cd $repo
        npm run boot
        cd ..
      fi
    done
    cd ..;
  fi
done
popd
