#!/bin/bash

echo ""
echo "Search in [ROOTPATH], merge [IGNOREPATH/.gitignore.global.txt] and [ROOTPATH/*/.gitignore.local.txt] files to [seafile-ignore.txt]"
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

echo "::*** Enter [path to .gitignore.global.txt] or [leave blank] for default [[https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/.gitignore.global.txt]]" 
read -p "***:: " IGNOREPATH
if [ "$IGNOREPATH" ]
then
  if [ -d "$IGNOREPATH" ]
  then
    IGNOREPATH=$(realpath $IGNOREPATH)/.gitignore.global.txt
  fi
  if [ ! -f "$IGNOREPATH" ]
  then
    echo "××× Not found [[$IGNOREPATH]]. Exit now..."
    exit
  else
    echo "√√√ IGNOREPATH = [[$IGNOREPATH]]"
  fi
else
  IGNOREPATH=https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/.gitignore.global.txt
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
    if [ -f "$IGNOREPATH" ]
    then
      cat $IGNOREPATH > $repo/.gitignore
    else
      curl -sSL $IGNOREPATH | cat > $repo/.gitignore
    fi
    cat $repo/.gitignore.local.txt 2>/dev/null >> $repo/.gitignore
    echo ""
  fi
done

cd -
