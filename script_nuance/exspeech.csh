#!/bin/csh

source ~/bin/platform.csh

#if ("$1" == '') then
#    echo "Which ExSpeech?"
#    echo -n "Please enter a ExSpeech version, e.g. 2006-02-02: "
#    set selection=$<
#else
#    set selection=$1
#endif 

echo "Use current ExSpeech version:"
set selection='current'

# todo: check existence of osr installation!
if ("$PLATFORM" == 'aachen_windows') then 
    echo "ExSpeech $selection isn't implemented on Aachen Windows."
else if ("$PLATFORM" == 'aachen_linux') then
    echo "ExSpeech $selection isn't implemented on Aachen Linux."
else if ("$PLATFORM" == 'burlington_linux') then
    source /res/tools/ExSpeech/current/setenv.csh 
    echo "ExSpeech $selection was successfully configured on Burlington Linux."
else if ("$PLATFORM" == 'home_windows') then
    echo "ExSpeech $selection isn't implemented on Home Windows."
else
    echo "Unknown System! Nothing was configured."
endif
