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
if [ -f /etc/profile ]
then
  . /etc/profile
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
#if [ -e ~/bin/addpath.sh ]  then 
#  . ~/bin/addpath.sh ~/bin
#fi

# Define aliases:

# Think twice before deletion. Though troublesome but strongly recommended!
alias rm='rm -i'

# Request X tunneling for SSH:
alias ssh='ssh -C -X'

# Do not verify Host Key change:
alias sshtrust='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# Always use compression for CVS:
alias cvs='cvs -z9'

alias ps='ps -elf'

alias emacst='emacs -nw'

alias myip='ifconfig | grep netmask'

# Always list long directory and time.
if [[ "$(uname)" = "Darwin" ]];
then
  alias l='ls -lG'
  alias ll='ls -lGA' # show .xxx 
  alias dir='ls -lGA'
  alias lll='ls -lGa' # show .xxx and . and ..
  export HOMEBREW_NO_AUTO_UPDATE=true
  export BASH_SILENCE_DEPRECATION_WARNING=1
else
  alias l='ls -l --color=auto' # --time-style=long-iso --color=auto'
  alias ll='ls -lA --color=auto'
  alias dir='ls -lA --color=auto'
  alias lll='ls -la --color=auto'
  export TIME_STYLE='+%Y-%m-%d--%H:%M:%S' 
fi
#export LS_OPTIONS='--color=auto' # 如果没有指定，则自动选择颜色
#export CLICOLOR='Yes'            #是否输出颜色
#export LSCOLORS='CxfxcxdxbxegedabagGxGx' #指定颜色

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
	;;
    *)
	;;
esac

# nvm settings
if [ -d $HOME/.nvm ]
then
  # 注意，这句 export 导致 `su` 会继承原用户的环境变量 NVM_DIR=/home/原用户/.nvm，可能导致不符合预期的行为。因此要 `su -` 更安全。
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# acme.sh settings
if [ -f $HOME/.acme.sh/acme.sh.env ]
then
  . "$HOME/.acme.sh/acme.sh.env"
  alias acme=$HOME/.acme.sh/acme.sh
fi

# let MacOS uses the same variable so that vscode-sshfs can use "$USERPROFILE/.ssh/id_rsa" uniformly.
export USERPROFILE=$HOME

# add sysconfig to path
tp1=/Users/luk.lu/faronear/fon/sysconfig
tp2=/Users/luk.lu/faronear/fon.git/sysconfig
tp3=/faronear/fon/sysconfig
tp4=/faronear/fon.git/sysconfig
tp5=/mnt/c/faronear/fon.git/sysconfig
tp6=/mnt/d/faronear/fon.git/sysconfig
if [ -d $tp1 ]
then
  export PATH=$tp1:$PATH
elif [ -d $tp2 ]
then 
  export PATH=$tp2:$PATH
elif [ -d $tp3 ]
then
  export PATH=$tp3:$PATH
elif [ -d $tp4 ]
then 
  export PATH=$tp4:$PATH
elif [ -d $tp5 ]
then
  export PATH=$tp5:$PATH
elif [ -d $tp6 ]
then
  export PATH=$tp6:$PATH
fi

if [ -f ~/.bashrc_custom ]
then
	source ~/.bashrc_custom
fi

################################################################################
# End Of File: "~/.bashrc"
################################################################################
