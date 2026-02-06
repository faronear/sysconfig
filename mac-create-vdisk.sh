#!/usr/bin/env bash

set -e

DISKNAME=vdisk
DISKSIZE=33554432 # 磁盘扇区数，每个扇区大小是 512 字节，n*1024*1024*1024/512 = n Gigabytes. Do NOT set the formula to DISKSIZE.
# 虚拟磁盘并不是一创建就把内存空间划走，而是等到真正写入了虚拟磁盘的时候，才会使用对应的内存空间，所以给虚拟磁盘分配大一点的空间是没有问题的

if [ -d /Volumes/$DISKNAME ]; then
  echo 'Found /Volumes/$DISKNAME!'
else
  DISKID=$(hdid -nomount ram://$DISKSIZE)
  diskutil apfs create ${DISKID} $DISKNAME
fi

# copy this script to some public folder, e.g. `sudo cp $(basename $0) /etc/`, because in my test, it doesn't work in /Users/...
# copy the corresponding plist file to /Library/LaunchDaemons/,
# optionally run `sudo launchctl load /Library/LaunchDaemons/my-launch-file.plist` immediately for test.
