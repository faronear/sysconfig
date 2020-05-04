#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  read -p "Enter path to pull (leave blank for default ./) >> " FONPATH
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
        if [ -d $repo ]
          then
            echo '>>>>>> git pull' $org/$repo
            cd $repo
            git pull
            cd ..
        fi
      done
      cd ..;
  fi
done
popd