#!/bin/csh

source ~/bin/platform.csh

#if ("$1" == '') then
#    echo "Which GCC?"
#    echo -n "Please enter a GCC version, e.g. 3.4.2: "
#    set selection=$<
#else
#    set selection=$1
#endif

echo "Assume GCC 4.1.0"
set selection='4.1.0'

# todo: check existence of osr installation!
if ($PLATFORM == 'aachen_windows') then 
    echo "GCC $selection is unavailable on Aachen Windows."
else if ($PLATFORM == 'aachen_linux') then 
    source ~/bin/addpath.csh /usr/localbin/gcc-$selection-posix-fPIC/bin
    source ~/bin/addlibpath.csh /usr/localbin/gcc-$selection-posix-fPIC/lib
    echo "GCC $selection was successfully configured on on Aachen Linux."
else if ($PLATFORM == 'burlington_linux') then 
    source ~/bin/addpath.csh /usr/local/gcc-$selection/bin
    source ~/bin/addlibpath.csh /usr/local/gcc-$selection/lib
    echo "GCC $selection was successfully configured on Burlington Linux."
else if ("$PLATFORM" == 'home_windows') then
    echo "GCC $selection is unavailable on Home Windows."
else
    echo "Unknown system! Nothing was configured."
endif
