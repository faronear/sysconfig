#!/bin/bash

echo "Usage: setup.sh"
echo "Example: setup.sh"

echo "######## Setting Home ##################"

if [ -e ~/.emacs ]
then
  mv ~/.emacs ~/.emacs.backup
fi
ln -s /faronear/lib/sysconfig/.emacs ~/

if [ -e ~/.emacs.lisp ]
then
  mv ~/.emacs.lisp ~/.emacs.lisp.backup
fi
ln -s /faronear/lib/sysconfig/.emacs.lisp ~/

if [ -e ~/.bashrc ]
then
  mv ~/.bashrc ~/.bashrc.backup
fi
ln -s /faronear/lib/sysconfig/.bashrc ~/

if [ -e ~/.bash_profile ]
then
  mv ~/.bash_profile ~/.bash_profile.backup
fi
ln -s /faronear/lib/sysconfig/.bash_profile ~/

. ~/.bashrc

echo "######## Home Setting Complete ##################"
