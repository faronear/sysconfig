################################################################################
# File:     "~/.cshrc"
# Intro:    Personal startup script for CSH.
# Author:   Leiqin Lu
# See also: personal login script for CSH, "~/.login";
#           system login script for CSH, e.g. "/etc/csh.login" or "/etc/.login".
################################################################################

# Define PATH:
#if (-e ~/bin/addpath.csh) then
#    source ~/bin/addpath.csh ~/bin
#endif

# Define primary prompt (default is '%'):
set prompt="[%n@%m:%~]C " # %c shows top-level directory; %~ shows full path.

# Always use ssh to connect to CVS repositories:
setenv CVS_RSH ssh

# Define some special settings:
# set noclobber # Don't redirect output to existing files
# set ignoreeof # ignore EOF (^D) for this shell
# set history=100 savehist=50 # keep a history list and save it between logins

# Define aliases:
# Always list long directory and time. 
alias ll ls -al --time-style=long-iso --color=auto
# Think twice before deletion. Though troublesome but strongly recommended!
alias rm rm -i
# Request X tunneling for SSH:
alias ssh ssh -C -X
# Do not verify Host Key change:
alias sshtrust ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
# Always use compression for CVS:
alias cvs cvs -z9

# Set default file permission mask:
umask 022 # rwxr-xr-x

# If this is an xterm set the title to user@host:dir
# $USERNAME and $USER are both empty during execution of .bashrc. 
# PROMPT_COMMAND is expanded only when used.
switch ($TERM)
case "xterm*":
    alias precmd 'echo -n "\033]0;[${USER}@${HOST}:$cwd]C\007"'
    breaksw
case "dumb*":
    alias ll ls -al --time-style=long-iso
    breaksw
default:
    breaksw
endsw

################################################################################
# End Of File: "~/.cshrc"
################################################################################
