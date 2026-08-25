#!/bin/bash

################################################################################
# template for checking platform to set platform-specific environment.
################################################################################
PLATFORM=`hostname | perl -ne 'if (/AC-/) {exec "echo aachen_linux"} elsif (/leiqin/) {exec "echo aachen_windows"} elsif (/xena|cvshost/) {exec "echo burlington_unix"}'`

if [ $PLATFORM == 'aachen_windows' ]
then 
    echo "$PLATFORM: do something"
elif [ $PLATFORM == 'aachen_linux' ]
then 
    echo "$PLATFORM: do something"
else
  echo "Unknown System: nothing has been performed!"
fi

################################################################################
# template for system-specific settings
################################################################################
HOST=`/bin/hostname`
OS_TYPE=`/bin/uname -s`
OS_REL=`/bin/uname -r`
CPU=`/usr/localbin/cpu`
OS=`/usr/localbin/os`

if [ $HOST == '???' ]
then . ~/???.sh
elif [ $HOST == '???' ]
then . ~/???.sh
else
    echo "Unknown system $HOST."
fi

####################################
# you must use double quote around $1, because it's a shell variable and replaced by shell directly.
if [ "$1" == "" ] # it's always safer to quote variables in shell script.

if [ condition ]
then # then must be on a seperate line!
    cmds
elif [ condition ] 
    cmds
else
    cmds
fi

################################################################################
#*******************************************************************************
################################################################################

#~/bin/csh

################################################################################
# template for system-specific settings
################################################################################
set host=`/bin/hostname`
set os_type=`/bin/uname -s`
set os_rel=`/bin/uname -r`
#set cpu=`/usr/localbin/cpu`
#set os=`/usr/localbin/os`

if ($host == "hydra") then  # the then must be in the same line of if
    source ~/cshrc.hydra.csh
else if ($host == "AC-Albatross") then 
    source ~/cshrc.ac-linux.csh
else 
    echo "Unknown system $host."
endif

if ( condition ) then # then must be on the same line!
    cmds
else if ( condition )
    cmds
else
    cmds
endif
