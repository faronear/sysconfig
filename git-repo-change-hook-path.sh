#!/bin/bash

echo "in [REPOROOT]/*/*/hooks/[pre-receive.d|post-receive.d|update.d]/gitea, path is hard-coded in full such as `/faronear/git/gitea/gitea hook --config=/faronear/git/gitea/custom/conf/app.ini`, you need to replace it if the path is changed."
echo "[20230305] noticed that gitea 1.18.5 default is `/usr/local/bin/gitea hook --config=/data/gitea/conf/app.ini`"

echo "=== Enter [old hook path string] or [leave blank] for default '/faronear/git/gitea/gitea':" 
read -p ">>> " OLDPATH
if [ ! "$OLDPATH"]
then
  OLDPATH=/faronear/git/gitea/gitea
fi

echo "=== Enter [new hook path string] or [leave blank] for default '/usr/local/bin/gitea': "
read -p ">>> " NEWPATH
if [ ! "$NEWPATH" ]
then
  NEWPATH=/usr/local/bin/gitea
fi

echo "=== Enter [root path] of repositories, or [leave blank] for default [[]]`pwd`]] "
read -p ">>> " REPOROOT
if [ "$ROOTPATH"]
then
  ROOTPATH=`realpath $ROOTPATH`
else
  ROOTPATH=`pwd`
fi

echo "=== Enter [y] to start updating, or [anything else] to quit"
read -p ">>> " YESNO
if [ "$YESNO" != 'y' ]
then
  exit
fi

# 用 : 来取代 /，以避免大量出现 \/ 
# sed -i "s/\/home\/fon\//\/root\//g" `grep '/home/fon' -rl git.repo/*/*/hooks/*.d/gitea`
sed -i "s:$OLDPATH:$NEWPATH:g" `grep "$OLDPATH" -rl $REPOROOT/*/*/hooks/*.d/gitea`

echo "Completed replacing $OLDPATH to $NEWPATH recursively in folder $REPOROOT"
