#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  read -p "Enter faronear path to npm boot (leave blank for default ../..) >> " FONPATH
  if [ ! $FONPATH ]
  then
    FONPATH=../..
  fi
fi

if [ ! -d $FONPATH ]
then 
  echo "*** [$FONPATH] not exist! Exit now. ***"
  exit
fi

pushd $FONPATH
echo "*** Current path = [`pwd`] ***"
for org in `ls .`
do 
  if [ -d $org ]
  then
    cd $org;
    for repo in `ls .`
    do
      if [ -f $repo/package.json ]
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