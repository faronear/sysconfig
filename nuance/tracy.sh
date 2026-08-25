#!/bin/bash

. ~/bin/platform.sh

#if [ "$1" == '' ] then
#    echo "Which TRACY?"
#    echo -n "Please enter a TRACY version, e.g. 880: "
#    read selection
#else
#    selection=$1
#fi

echo "Currently only TRACY 880 is supported."
echo "Assume TRACY 880"
selection='880'

# todo: check existence of osr installation!
if [ "$PLATFORM" == 'aachen_windows' ] 
then 
    echo "Tracy $selection is unavailable on Aachen Windows."
elif [ "$PLATFORM" == 'aachen_linux' ] 
then
    echo "In Aachen Linux only tracy 10/880 is supported:"
    export TRACYDIR=/u_grid/ac-green/llu/tracy/tracy10_880
    if [ "" == "" ] 
    then
	compdir="ilgi"
    else
	compdir=""
    fi
    . ~/bin/addpath.sh /usr/localbin/python2.4/bin:$TRACYDIR/bin/:$TRACYDIR/scripts:$TRACYDIR/scripts/build:$TRACYDIR/scripts/tools/osr
    if [ -z PYTHONPATH ] 
    then
	export PYTHONPATH=$TRACYDIR/lib/python:$TRACYDIR/lib/${compdir}:${PYTHONPATH}
    else
	export PYTHONPATH=$TRACYDIR/lib/python:$TRACYDIR/lib/${compdir}
    fi
	    
    if [ $?LD_LIBRARY_PATH ] 
    then
	export LD_LIBRARY_PATH=$TRACYDIR/lib/${compdir}:${LD_LIBRARY_PATH}
    else
	export LD_LIBRARY_PATH=$TRACYDIR/lib/${compdir}
    fi
		
    export PERL5LIB=$TRACYDIR/lib/perl
    echo "Tracy 10/880 was successfully configured on Aachen Linux."
elif [ "$PLATFORM" == 'burlington_linux' ] 
then
    . /res/tools/tracy/release/tracy$selection/setenv.sh 
    echo "Tracy $selection was successfully configured on Burlington Linux."
elif [ "$PLATFORM" == 'home_windows' ] 
then
    echo "Tracy $selection is unavaible on Home Windows."
else
    echo "Unknown System! Nothing was configured."
fi
