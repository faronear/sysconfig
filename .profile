################################################################################
# File:     "~/.profile"
# Intro:    Personal startup script for SH (Bourne Shell).
# Author:   Leiqin Lu
# See also: system startup script for SH, e.g. "/etc/profile".
################################################################################

# Define PATH:
###

# Always use ssh to connect to CVS repositories:
CVS_RSH=ssh

# Define primary prompt (default is '$'):
PS1="[\u@\h:\w]S "

# Define some functions:
#ls() { /bin/ls -sbF "$@";}
#ll() { ls -al --time-style=long-iso "$@";}
# Think twice before deletion. Though troublesome but strongly recommended!
#rm() { rm -i;}
# Request X tunneling for SSH:
#ssh() { ssh -C -X;}
# Always use compression for CVS:
#cvs() { cvs -z9;}

# Set default file permission mask:
umask 022 # rwxr-xr-x

################################################################################
# End Of File: "~/.profile"
################################################################################
