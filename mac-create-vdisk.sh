#!/usr/bin/env bash

set -e

DISKNAME=vdisk
DISKSIZE=50331648  # 磁盘扇区数，每个扇区大小是 512 字节，1 Gigabytes 有 1024*1024*1024/512 = 2097152 扇区.
# 虚拟磁盘并不是一创建就把内存空间划走，而是等到真正写入了虚拟磁盘的时候，才会使用对应的内存空间，所以给虚拟磁盘分配大一点的空间是没有问题的

if [ -d /Volumes/$DISKNAME ]; then
  echo 'Found /Volumes/$DISKNAME!'
else
  DISKID=$(hdid -nomount ram://$DISKSIZE)
  diskutil apfs create ${DISKID} $DISKNAME
fi

cat <<'EOF' > /Volumes/$DISKNAME/seafile-ignore.txt
# 特殊定制
*.mp4

# 自定义的后缀名，凡有 sfignore 后缀的都不进行同步
*.sfignore
*.sfignore/
*.sfignore.*
*.sfignore.*/
*.sfomit
*.sfomit.*
*.sfomit/
*.sfomit.*/
*.nosf
*.nosf.*
*.nosf/
*.nosf.*/

## everything 'git pull or fetch' will update `.git/FETCH_HEAD`, even if the content doesn't change. To avoid too many useless updates of this file in Seafile history:
FETCH_HEAD
*/FETCH_HEAD

.Trash/
.Trashes/

.DS_Store
*/.DS_Store
*.aae # AAE 文件主要在苹果的照片应用程序中使用，保存对原始照片所做的编辑，比如，裁剪、旋转或调整亮度等操作的信息。

.thumbnails
*/.thumbnails

Thumbs.db
*/Thumbs.db
thumbs.db
*/thumbs.db

_desktop.ini
*/_desktop.ini

._*
*/._*

.$*
*/.$*

~$*
*/~$*

node_modules/
*/node_modules/
package-lock.json
*/package-lock.json

pages4loader.json5
*/pages4loader.json5

.deploy_git/
*/.deploy_git/

# next.js 项目
.next/
*/.next/

# HBuilder 目录
unpackage/
*/unpackage/

Icon
OneDrive/Icon

# wrangler project

.dev.vars*
*/.dev.vars*
.wrangler/
*/.wrangler/
EOF

# copy this script to some public folder, e.g. `sudo cp $(basename $0) /etc/`, because in my test, it doesn't work in /Users/...
# copy the corresponding plist file to /Library/LaunchDaemons/,
# optionally run `sudo launchctl load /Library/LaunchDaemons/my-launch-file.plist` immediately for test.
