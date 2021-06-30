#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  read -p "Enter path to npm boot (leave blank for default ./) >> " FONPATH
  if [ ! $FONPATH ]
  then
    echo Use default path: ./
    FONPATH=./
  fi
fi

pushd $FONPATH
for org in `ls .`
do 
  if [ -d $org ]
    then
      cd $org;
      for repo in `ls .`
      do
        if [ -d $repo/package.json ]
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