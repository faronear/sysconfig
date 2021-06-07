#!/bin/bash

. ~/bin/platform.sh

if [ "$PLATFORM" == 'aachen_windows' ]
then 
    echo "SGE is unavailable on Aachen Windows."
elif [ "$PLATFORM" == 'my_laptop' ]
then 
    echo "SGE is unavailable on my laptop."
elif [ "$PLATFORM" == 'aachen_linux' ]
then 
    if  [ -z "$SGE_ROOT" ] 
    then 
	. /opt/sge6/default/common/settings.sh
    fi
    echo "SGE was successfully configured on Aachen Linux."
elif [ "$PLATFORM" == 'burlington_linux' ]
then 
    if [ -z "$SGE_ROOT" ]
    then 
	. /usr/local/SGE/default/common/settings.sh
    fi
    # tools for Grid management:
    . ~/bin/addpath.sh /res/tools/contrib/script
    echo "SGE and Grid tools was successfully configured on Burlington Linux."
elif [ "$PLATFORM" == 'home_windows' ]
then
    echo "SGE is unavailable on Home Windows."
else
    echo "Unknown system! Nothing was configured."
fi
