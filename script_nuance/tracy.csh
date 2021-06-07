#!/bin/csh

source ~/bin/platform.csh

if ("$1" == '') then
    echo "Which TRACY?"
    echo -n "Please enter a TRACY version, e.g. 10/880 or 11/204: "
    set selection=$<
else
    set selection=$1
endif 

# todo: check existence of osr installation!
if ("$PLATFORM" == 'aachen_windows') then 
    echo "Tracy $selection is unavailable on Aachen Windows."
else if ("$PLATFORM" == 'aachen_linux') then
    echo "In Aachen Linux only tracy 10/880 is supported."
    setenv TRACYDIR /u_grid/ac-green/llu/tracy/tracy10_880
    if ( "" == "" ) then
	set compdir="ilgi"
    else
	set compdir=""
    endif
    source ~/bin/addpath.csh /usr/localbin/python2.4/bin:$TRACYDIR/bin/:$TRACYDIR/scripts:$TRACYDIR/scripts/build:$TRACYDIR/scripts/tools/osr
    if ( $?PYTHONPATH ) then
	setenv PYTHONPATH $TRACYDIR/lib/python:$TRACYDIR/lib/${compdir}:${PYTHONPATH}
    else
	setenv PYTHONPATH $TRACYDIR/lib/python:$TRACYDIR/lib/${compdir}
    endif
	    
    if ( $?LD_LIBRARY_PATH ) then
	setenv LD_LIBRARY_PATH $TRACYDIR/lib/${compdir}:${LD_LIBRARY_PATH}
    else
	setenv LD_LIBRARY_PATH $TRACYDIR/lib/${compdir}
    endif

    setenv PERL5LIB $TRACYDIR/lib/perl
    echo "Tracy 10/880 was successfully configured on Aachen Linux."
else if ("$PLATFORM" == 'burlington_linux') then
    source /res/tools/tracy/release/tracy$selection/setenv.csh 
    echo "Tracy $selection was successfully configured on Burlington Linux."
else if ("$PLATFORM" == 'home_windows') then
    echo "Tracy $selection is unavaible on Home Windows."
else
    echo "Unknown System! Nothing was configured."
endif
