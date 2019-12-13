#!/bin/bash

echo "Usage: setup.sh"
echo "Example: setup.sh"

echo "######## 安装 ##################"
mv ~/.bashrc ~/.bashrc.backup
ln -s /faronear/lib/sysconfig/.emacs ~/
ln -s /faronear/lib/sysconfig/.emacs.lisp ~/
ln -s /faronear/lib/sysconfig/.bashrc ~/
ln -s /faronear/lib/sysconfig/.bash_profile ~/
. ~/.bashrc
git config --global credential.helper cache
echo "######## 完毕 ##################"
