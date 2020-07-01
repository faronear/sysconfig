################################################################################
# File:     "~/.bash_profile"
# Intro:    Personal login script for BASH.
# Author:   Leiqin Lu
# See also: personal logout script for BASH, "~/.bash_logout";
#           system login script for BASH, "/etc/profile";
#           personal startup script for BASH, "~/.bashrc";
#           system startup script for BASH, "/etc/bashrc".
################################################################################

# Execute personal startup script for BASH
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
unset USERNAME

################################################################################
# End Of File: "~/.bash_profile"
################################################################################
