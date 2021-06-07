#!/bin/csh

# test my new version.

source ~/bin/platform.csh

if ("$PLATFORM" == 'aachen_windows') then 
    echo "SGE is unavailable on Aachen Windows."
elif ("$PLATFORM" == 'my_laptop') then 
    echo "SGE is unavailable on my laptop."
else if ("$PLATFORM" == 'aachen_linux') then 
    if  ( $?SGE_ROOT == 0 ) then 
	source /opt/sge6/default/common/settings.csh
    endif
    echo "SGE was successfully configured on Aachen Linux."
else if ("$PLATFORM" == 'burlington_linux') then 
    if ( $?SGE_ROOT == 0 ) then 
	source /usr/local/SGE/default/common/settings.csh
    endif
    # tools for Grid management:
    source ~/bin/addpath.csh /res/tools/contrib/script
    echo "SGE and Grid tools was successfully configured on Burlington Linux."
else if ("$PLATFORM" == 'home_windows') then
    echo "SGE is unavailable on Home Windows."
else
    echo "Unknown system! Nothing was configured."
endif
