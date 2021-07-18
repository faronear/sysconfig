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
for org in `ls .`
do 
  if [ -d $org ]
  then
    cd $org;
    for repo in `ls .`
    do
      if [ -d $repo/.git ]
        then
          echo "--- git pulling: $org/$repo"
          cd $repo
          git pull
          cd ..
      fi
    done
    cd ..;
  fi
done
popd

get_char()
{
  SAVEDSTTY=`stty -g`
  stty -echo
  stty cbreak
  dd if=/dev/tty bs=1 count=1 2> /dev/null
  stty -raw
  stty echo
  stty $SAVEDSTTY
}
echo "Press any key to exit!"
char=`get_char`