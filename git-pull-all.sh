#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  read -p "Enter path to git pull (leave blank for default ../..) >> " FONPATH
  if [ ! $FONPATH ]
  then
    FONPATH=../..
  fi
fi
echo ">> Goto $FONPATH as base directory"

pushd $FONPATH
echo ">> `pwd`"
for org in `ls .`
do 
  if [ -d $org ]
    then
      cd $org;
      for repo in `ls .`
      do
        if [ -d $repo/.git ]
          then
            echo '>>>>>> git pulling: ' $org/$repo
            cd $repo
            git pull
            cd ..
        fi
      done
      cd ..;
  fi
done
popd