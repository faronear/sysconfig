#!/bin/bash

echo "Usage: setup.sh [VERSION]"
echo "Example: setup.sh"

sudo apt update

echo "######## 安装 ##################"
ln -s ~/home.config/.emacs ~/
ln -s ~/home.config/.emacs.lisp ~/
ln -s ~/home.config/.bashrc ~/
ln -s ~/home.config/.bash_profile ~/
