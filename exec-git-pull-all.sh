#!/bin/bash

if [ $1 ]
then
  FONPATH=$1
else
  read -p "Enter path-to-faronear " FONPATH
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