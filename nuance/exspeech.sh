#!/bin/bash

. ~/bin/platform.sh

#if [ "$1" == '' ] then
#    echo "Which ExSpeech?"
#    echo -n "Please enter an ExSpeech version, e.g. 2006-02-02: "
#    read selection
#else
#    selection=$1
#fi

echo "Use current ExSpeech version:"
selection='current'

# todo: check existence of osr installation!
if [ "$PLATFORM" == 'aachen_windows' ] 
then 
    echo "ExSpeech $selection isn't implemented on Aachen Windows."
elif [ "$PLATFORM" == 'aachen_linux' ] 
then
   echo "ExSpeech $selection isn't implemented on Aachen Linux."
elif [ "$PLATFORM" == 'burlington_linux' ] 
then
    . /res/tools/ExSpeech/current/setenv.sh 
    echo "ExSpeech $selection was successfully configured on Burlington Linux."
elif [ "$PLATFORM" == 'home_windows' ] 
then
   echo "ExSpeech $selection isn't implemented on Home Windows."
else
    echo "Unknown System! Nothing was configured."
fi
