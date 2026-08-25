#!/bin/bash

# usage: . addlibpath.sh new_path

# this script requires a normalized $LD_LIBRARY_PATH: 
# 1. each path except the last one must be followed by ":" without any whitespace; 
# 2. each path is NOT finished by "/"
# besides, the input parameter $1 is NOT finished by "/".
# Purpose of the normalization is to match $ENV{NEWPATH}(:\|$)

# it must be explicitly exported because Perl only add environment variables to %ENV, not those shell variables:
export NEWPATH=$1  
# on windows, we must use /usr/bin/perl from cygwin, because ActivePerl doesn't work on following line:
if [ 'no' == `/usr/bin/perl -e 'if ($ENV{LD_LIBRARY_PATH} =~ m|$ENV{NEWPATH}(:\|$)|) {exec "echo yes"} else {exec "echo no"}'` ]
then
    if [ -z ${LD_LIBRARY_PATH} ]
    then
	export LD_LIBRARY_PATH=$1
    else
	export LD_LIBRARY_PATH=$1:${LD_LIBRARY_PATH}
    fi
fi
