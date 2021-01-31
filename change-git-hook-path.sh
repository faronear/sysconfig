#!/bin/bash

read -p "Enter old hook path: >> " OLDPATH
read -p "Enter new hook path: >> " NEWPATH
read -p "Enter repository root path: >> " REPOROOT

echo '$REPOROOT'
echo "$REPOROOT"

sed -i "s:$OLDPATH:$NEWPATH:g" `grep "$OLDPATH" -rl $REPOROOT/*/*/hooks/`

echo "Completed replacing $OLDPATH to $NEWPATH recursively in folder $REPOROOT"

# 参数 -i 代表在文件里直接替换。但发现在 MacOS 里这会报错，在 Debian 里没问题。
# 可以用 : 来取代 /，以避免大量出现 \/ 
# sed -i "s/\/home\/fon\//\/root\//g" `grep '/home/fon' -rl git.repo/*/*/hooks`
