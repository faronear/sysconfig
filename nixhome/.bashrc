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

# Set aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias su='su -'
if [[ "$(uname)" = "Darwin" ]];
then
  alias l='ls -lG'
  alias ll='ls -lGA' # show .xxx 
  alias dir='ls -lGA'
  alias lll='ls -lGa' # show .xxx and . and ..
  alias sedi='sed -i ""'
  export HOMEBREW_NO_AUTO_UPDATE=true
  export BASH_SILENCE_DEPRECATION_WARNING=1
else
  alias l='ls -l --color=auto' # --time-style=long-iso --color=auto'
  alias ll='ls -lA --color=auto'
  alias dir='ls -lA --color=auto'
  alias lll='ls -la --color=auto'
  alias sedi='sed -i'
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

############## following settings copied from amazon's debian ####################
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]] '
else
    PS1='[${debian_chroot:+($debian_chroot)}\u@\h:\w] '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
############## above settings copied from amazon's debian ####################

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
tp7=/faronear/sysconfig
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
elif [ -d $tp7 ]
then
  export PATH=$tp7:$PATH
fi

if [ -f ~/.bashrc_custom ]
then
	source ~/.bashrc_custom
fi

################################################################################
# End Of File: "~/.bashrc"
################################################################################
