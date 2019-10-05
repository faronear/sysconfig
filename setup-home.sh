#!/bin/bash

echo "Usage: setup.sh"
echo "Example: setup.sh"

echo "######## 安装 ##################"
ln -s ~/linux.config/.emacs ~/
ln -s ~/linux.config/.emacs.lisp ~/
ln -s ~/linux.config/.bashrc ~/
ln -s ~/linux.config/.bash_profile ~/
. ~/.bashrc
echo "######## 完毕 ##################"
