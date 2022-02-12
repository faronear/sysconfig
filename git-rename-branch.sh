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
for org in '*'
do 
  if [ -d $org ]
  then
    echo "  entering [$FONPATH/$org]"
    cd $org;
    for repo in *
    do
      if [ -d $repo/.git ]
      then
        cd $repo
          # echo "    changing repo url to [$FONPATH/$org/$repo]"
          # git remote remove origin
          # git remote add origin https://git.faronear.org/$org/$repo
          # git pull
          # git branch --set-upstream-to=origin/main main
          # git pull
          echo "    renaming master branch to main"
          git branch -m master main
          git push -u origin main
          git push origin :master
        cd ..
      fi
    done
    cd ..;
  fi
done
popd
