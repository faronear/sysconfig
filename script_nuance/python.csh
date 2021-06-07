#!/bin/csh

source ~/bin/platform.csh

#if ( "$1" == '' ) then
#    echo "Which Python?"
#    echo -n "Please enter a Python version, e.g. 2.4: "
#    set selection=$<
#else
#    set selection=$1
#endif

echo "Currently only Python 2.4 is supported."
echo "Assume Python 2.4"
set selection='2.4'

# todo: check existence of osr installation!
if ( $PLATFORM == 'aachen_windows' ) then 
    echo "Python $selection is unavailable on Aachen Windows."
else if ( $PLATFORM == 'aachen_linux' ) then 
    source ~/bin/addpath.csh /usr/localbin/python$selection/bin
    echo "Python $selection was successfully configured on on Aachen Linux."
else if ( $PLATFORM == 'burlington_linux' ) then 
    echo "Python $selection is unavailable on Burlington Linux."
else if ( "$PLATFORM" == 'home_windows' ) then
    echo "Python $selection is unavailable on Home Windows."
else
    echo "Unknown system! Nothing was configured."
endif
