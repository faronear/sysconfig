#!/bin/bash

if [ -d "$1" ]
then
  FONPATH=$1
else
  echo "××× All testing path failed."
  echo ""
  echo "=== Enter [fonpath] or leave [blank] for default to '.'"
  read -p ">>> " FONPATH
  echo ""
  if [ ! "$FONPATH" ]
  then
    FONPATH=.
  fi
fi

if [ ! -d "$FONPATH" ]
then 
  echo "××× [$FONPATH] not exist! Exit now. ***"
  exit
else
  echo "√√√ FONPATH = $FONPATH"
fi

pushd $FONPATH
echo "*** Starting from [`pwd`] ***"
echo ""

echo "=== Enter [commit message] or leave [blank] for default to 'updated'"
read -p ">>> " COMMIT_MESSAGE
if [ ! "$COMMIT_MESSAGE" ]
then
  COMMIT_MESSAGE="updated"
fi
echo ""

if [ "$2" == 'hier' ]
then
  # for org in `ls -F | grep '/$' | grep -v '~'` ## 首先过滤出所有子目录，然后过滤出所有不含 ~ 的子目录。注意 for ??? in `ls ???` 是按照空行以及空格进行分割的，因此最后筛选出的目录名不能含有空格，否则就被分割成多个了。
  ls -F | grep '/$' | grep -v 'node_modules' | while read org ## 换用这种方法，可以成功过滤出含有空格的完整目录名
  do 
    echo "======== entering [$FONPATH/$org] ========"
    echo ""
    cd "$org";
    for repo in * ## for ??? in * 是分割成一个个目录名的，即使目录名含有空格
    do
      if [ -d "$repo/.git" ]
      then
        echo "---- git commit & push [`pwd`/$repo] ----"
        pushd "$repo"
        git add . && git commit -m "$COMMIT_MESSAGE" && git push
        echo ""
        popd
      fi
    done
    cd ..
  done
else
  find . -mindepth 1 -maxdepth 3 -type d -name '[^.]*' | grep -E -v 'node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl' | while read repo
  do 
    if [ -d "$repo/.git" ]
    then
      echo "---- git commit & push [$repo] ----"
      pushd "$repo"
      git add . && git commit -m "$COMMIT_MESSAGE" && git push
      echo ""
      popd
    fi
  done
fi

popd
