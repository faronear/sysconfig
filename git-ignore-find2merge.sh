#!/bin/bash

echo ""
echo "Search in [ROOTPATH], merge [GLOBALPATH/.gitignore_global] and [ROOTPATH/*/.gitignore.local.txt] files to .gitignore"
echo ""

if [ -d "$1" ]
then
  ROOTPATH=$1
else
  echo "::*** Enter [root path] or [leave blank] for default [[`pwd`]] to start tree search for git repositories"
  read -p "***:: " ROOTPATH
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

echo "::*** Enter [path to .gitignore_global] or [leave blank] for default [[https://git.tic.cc/open/sysconfig/raw/branch/main/nixhome/.gitignore_global]]" 
read -p "***:: " GLOBALPATH
if [ "$GLOBALPATH" ]
then
  if [ -d "$GLOBALPATH" ]
  then
    GLOBALPATH=$(realpath $GLOBALPATH)/.gitignore_global
  fi
  if [ ! -f "$GLOBALPATH" ]
  then
    echo "××× Not found [[$GLOBALPATH]]. Exit now..."
    exit
  else
    echo "√√√ GLOBALPATH = [[$GLOBALPATH]]"
  fi
else
  GLOBALPATH=https://git.tic.cc/open/sysconfig/raw/branch/main/nixhome/.gitignore_global
fi
echo ""

echo "::*** Enter [y] to start updating, or [anything else] to quit"
read -p "***:: " YESNO
if [ "$YESNO" != 'y' ]
then
  exit
fi

cd $ROOTPATH
echo "*** Starting from [[`pwd`]] ***"
echo ""

find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules|uni_modules|\.deploy_git|\.git|.svn|\.vscode|\.wrangler|unpackage|_webroot|_logstore|_datasotre|_archive|_filestore|_ssl' | while read repo
do 
  if [ -f "$repo/.gitignore" ] # some git repo need to keep privacy, therefore judge from .gitignore, not from .git
  then
    echo "---- updating [[$repo/.gitignore]] ----"
    if [ -f "$GLOBALPATH" ]
    then
      cat $GLOBALPATH > $repo/.gitignore
    else
      curl -sSL $GLOBALPATH | cat > $repo/.gitignore
    fi
    cat $repo/.gitignore.local.txt 2>/dev/null >> $repo/.gitignore
    echo ""
  fi
done

cd -
