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

alias rm='rm -i' # Think twice before deletion. Though troublesome but strongly recommended.
alias sshx='ssh -C -X' # Request X tunneling for SSH:
alias sshtrust='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' # Do not verify Host Key change:
alias cvs='cvs -z9' # Always use compression for CVS:
alias ps='ps -elf'
alias emacst='emacs -nw'
alias myip='ifconfig | grep netmask'
alias rclone='rclone -P'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias su='su -'
alias npmc='npm --registry https://registry.npmmirror.com'
alias npmr='npm -s run'
alias curlw='curl -sSL -o /dev/null -w "%{http_code} | %{time_total} s | %{size_download} bytes | %{url_effective}\n"'
if [ $(which aichat) ]
then
  alias ai='aichat'
  alias air='aichat -e'
  alias aic='aichat -c'
  alias aif='aichat --file'
fi
if [ "$(uname)" = "Darwin" ]
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

############## following settings copied from amazon's debian ####################
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

## uncomment for a colored prompt, if the terminal has the capability; turned
## off by default to not distract the user: the focus in a terminal window
## should be on the output of commands, not on the prompt
# force_color_prompt=yes
# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# 	# We have color support; assume it's compliant with Ecma-48
# 	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# 	# a case would tend to support setf rather than setaf.)
# 	color_prompt=yes
#     else
# 	color_prompt=
#     fi
# fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# color starts with \[\033[${Style};${Type}${Color}m\] and ends with \[\033[00m\].
# $Style: text style
# - `00`: Default style
# - `01`: Bold/Bright
# - `04`: Underlined
# - `05`: Blink (may not work in all terminals)
# - `07`: Inverse
# - `08`: Hidden
# $Type:
# - `3`: text
# - `4`: background
# $Color: color
# - `0`: Black
# - `1`: Red
# - `2`: Green
# - `3`: Yellow
# - `4`: Blue
# - `5`: Magenta
# - `6`: Cyan
# - `7`: White
# others:
# \w shows absolute path, \W shows current folder.

if [ "$(uname)" = "Darwin" ]; then
    MYOSVERSION=Mac`sw_vers -productVersion`
elif [ "$(uname)" = "FreeBSD" ]; then
    MYOSVERSION=$(echo "$(freebsd_version)" | cut -d'-' -f1)
elif [ -f /etc/debian_version ]; then
    MYOSVERSION=Deb`cat /etc/debian_version 2>/dev/null`
elif [ -f /etc/ubuntu_version ]; then
    MYOSVERSION=Ubt`cat /etc/ubuntu_version 2>/dev/null`
fi
if [[ -n "$SSH_CONNECTION" ]] || [[ "$(uname)" != "Darwin" ]]; then
    IN_SSH=">ssh"
fi
if [ "$color_prompt" = yes ]; then
    PS1='<\[\033[07;32m\]\t\[\033[00m\]#\[\033[07;35m\]\u\[\033[00m\]@\[\033[07;31m\]\h\[\033[00m\]=\[\033[07;34m\]$(uname -m),$(uname),$MYOSVERSION\[\033[00m\]:\[\033[07;36m\]\w\[\033[00m\]$IN_SSH> '
else
    PS1='<\t#\u@\h=$(uname -m),$(uname),$MYOSVERSION:\w$IN_SSH> ' # \w shows absolute path, \W shows current folder.
fi
unset color_prompt force_color_prompt

############## above settings copied from amazon's debian ####################

if [ "$(uname)" = "Darwin" ]; then
  if [ "$(uname -m)" = "arm64" ] && [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ "$(uname -m)" = "x86_64" ] && [ -f /usr/local/homebrew/bin/brew ]; then 
    eval "$(echo $(/usr/local/homebrew/bin/brew shellenv) | sed 's#HOMEBREW_CELLAR=.*$#HOMEBREW_CELLAR=/usr/local/Cellar#')"
  fi
fi

# nvm settings
if [ -d $HOME/.nvm ]; then
  # 注意，这句 export 导致 `su` 会继承原用户的环境变量 NVM_DIR=/home/原用户/.nvm，可能导致不符合预期的行为。因此要 `su -` 更安全。
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# fnm settings
# if [ $(which fnm) ]
# then
#   eval "$(fnm env --use-on-cd)"
# fi

# acme.sh settings
if [ -f $HOME/.acme.sh/acme.sh.env ]
then
  . "$HOME/.acme.sh/acme.sh.env"
  alias acme=$HOME/.acme.sh/acme.sh
fi

# let MacOS uses the same variable so that vscode-sshfs can use "$USERPROFILE/.ssh/id_rsa" uniformly.
export USERPROFILE=$HOME

# # add sysconfig to path
if [ -e ~/sysconfig ]
then
  export PATH=~/sysconfig:$PATH
fi

if [ -f ~/.bashrc_custom ]
then
	source ~/.bashrc_custom
fi

################################################################################
# End Of File: "~/.bashrc"
################################################################################
