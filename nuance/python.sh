#!/bin/bash

. ~/bin/platform.sh

#if [ "$1" == '' ] 
#then
#    echo "Which Python?"
#    echo -n "Please enter a Python version, e.g. 2.4: "
#    read selection
#else
#    selection=$1
#fi

echo "Currently only Python 2.4 is supported."
echo "Assume Python 2.4"
selection='2.4'

# todo: check existence of osr installation!
if [ $PLATFORM == 'aachen_windows' ]
then 
    echo "Python $selection is unavailable on Aachen Windows."
elif [ $PLATFORM == 'aachen_linux' ]
then 
    . ~/bin/addpath.sh /usr/localbin/python$selection/bin
    echo "Python $selection was successfully configured on on Aachen Linux."
elif [ $PLATFORM == 'burlington_linux' ]
then 
    echo "Python $selection is unavailable on Burlington Linux."
elif [ "$PLATFORM" == 'home_windows' ]
then
    echo "Python $selection is unavailable on Home Windows."
else
    echo "Unknown system! Nothing was configured."
fi
