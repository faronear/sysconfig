#!/bin/bash

. ~/bin/platform.sh

#if [ "$1" == '' ] 
#then
#    echo "Which GCC?"
#    echo -n "Please enter a GCC version, e.g. 3.4.2: "
#    read selection
#else
#    selection=$1
#fi

echo "Assume GCC 4.1.0"
selection='4.1.0'

# todo: check existence of osr installation!
if [ $PLATFORM == 'aachen_windows' ]
then 
    echo "GCC $selection is unavailable on Aachen Windows."
elif [ $PLATFORM == 'aachen_linux' ]
then 
    . ~/bin/addpath.sh /usr/localbin/gcc-$selection-posix-fPIC/bin
    . ~/bin/addlibpath.sh /usr/localbin/gcc-$selection-posix-fPIC/lib
    echo "GCC $selection was successfully configured on on Aachen Linux."
elif [ $PLATFORM == 'burlington_linux' ]
then 
    . ~/bin/addpath.sh /usr/local/gcc-$selection/bin
    . ~/bin/addlibpath.sh /usr/local/gcc-$selection/lib
    echo "GCC $selection was successfully configured on Burlington Linux."
elif [ "$PLATFORM" == 'home_windows' ]
then
    echo "GCC $selection is unavailable on Home Windows."
else
    echo "Unknown system! Nothing was configured."
fi
