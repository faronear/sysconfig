################################################################################
# File:     "~/.bashrc"
# Intro:    Personal startup script for BASH.
# Author:   Leiqin Lu
# See also: personal logout script for BASH, "~/.bash_logout";
#           personal login script for BASH, "~/.bash_profile";
#           system login script for BASH, "/etc/profile";
#           system startup script for BASH, "/etc/bashrc".
################################################################################

# User specific aliases and functions

# Execute system startup script:
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Define primary prompt (default is '$'):
export PS1='[\u@\h:\w] ' # \w shows absolute path, \W shows current folder.

# Always use ssh to connect to CVS repositories:
export CVS_RSH=ssh

# Define PATH:
# Note 1: Do not export PATH, because 
# 1. it is defined in startup script, so every shell gets it!
# 2. only shell needs this variable, other programs normally don't need it.
# Note 2: Add current directory to PATH is dangerous!
#if [ -e ~/bin/addpath.sh ] 
#  then 
#    . ~/bin/addpath.sh ~/bin
#fi

# Define aliases:
# Always list long directory and time.
alias ll='ls -l --color=auto' # --time-style=long-iso --color=auto'
alias l='ls -Al --color=auto'
# Think twice before deletion. Though troublesome but strongly recommended!
alias rm='rm -i'
# Request X tunneling for SSH:
alias ssh='ssh -C -X'
# Always use compression for CVS:
alias cvs='cvs -z9'

alias ps='ps -elf'

# Set default file permission mask:
umask 022 # rwxr-xr-x

# If this is an xterm set the title to user@host:dir
# $USERNAME and $USER are both empty during execution of .bashrc. 
# PROMPT_COMMAND is expanded only when used.
case "$TERM" in
    xterm*|rxvt*)
	PROMPT_COMMAND='echo -ne "\033]0;[${USER}@${HOSTNAME}:${PWD}]B\007"'
	;;
    dumb*)
	alias ll='ls -al --time-style=long-iso'
	;;
    *)
	;;
esac

################################################################################
# End Of File: "~/.bashrc"
################################################################################
