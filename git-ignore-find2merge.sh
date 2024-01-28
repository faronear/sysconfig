#!/bin/bash

echo ""
echo "Search in [ROOTPATH], merge [IGNOREPATH/.gitignore_global] and [ROOTPATH/*/.gitignore_local] files to [seafile-ignore.txt]"
echo ""

if [ -d "$1" ]
then
  ROOTPATH=$1
else
  echo "=== Enter [root path] or [leave blank] for default [[`pwd`]] to start tree search for git repositories"
  read -p ">>> " ROOTPATH
  if [ "$ROOTPATH" ]
  then
    ROOTPATH=$(realpath $ROOTPATH)
  else
    ROOTPATH=`pwd`
  fi
fi
if [ ! -d "$ROOTPATH" ]
then 
  echo "××× [[$ROOTPATH]] not exist! Exit now. ***"
  exit
else
  echo "√√√ ROOTPATH = [[$ROOTPATH]]"
fi
echo ""

echo "=== Enter [path to .gitignore_global] or [leave blank] for default [[`pwd`]]" 
read -p ">>> " IGNOREPATH
if [ "$IGNOREPATH" ]
then
  IGNOREPATH=$(realpath $IGNOREPATH)/.gitignore_global
else
  IGNOREPATH=`pwd`/.gitignore_global
fi
if [ ! -f "$IGNOREPATH" ]
then
  echo "××× Not found [[$IGNOREPATH]]. Exit now..."
  exit
else
  echo "√√√ IGNOREPATH = [[$IGNOREPATH]]"
fi
echo ""

echo "=== Enter [y] to start updating, or [anything else] to quit"
read -p ">>> " YESNO
if [ "$YESNO" != 'y' ]
then
  exit
fi

cd $ROOTPATH
echo "*** Starting from [[`pwd`]] ***"
echo ""

find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules|uni_modules|\.deploy_git|\.git|.svn|\.vscode|\.wrangler|unpackage|_webroot|_logstore|_datasotre|_archive|_filestore|_ssl' | while read repo
do 
  if [ -d "$repo/.gitignore" ] # some git repo need to keep privacy, therefore judge from .gitignore, not from .git
  then
    echo "---- updating .gitignore in [[$repo]] ----"
    cat $IGNOREPATH $repo/.gitignore_local 2>/dev/null > $repo/.gitignore
    echo ""
  fi
done

cd -
