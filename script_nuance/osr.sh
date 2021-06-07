#!/bin/bash

. ~/bin/platform.sh

if [ "$1" == '' ] 
then
    echo "Which OSR?"
    echo -n "Please enter an OSR version, e.g. osr309: "
    read selection
else
    selection=$1
fi

# todo: check existence of osr installation!
if [ "$PLATFORM" == 'aachen_windows' ] 
then 
    . ~/bin/addpath.sh ~/products/$selection/bin
    export PRODUCT_LIB_PREFIX=SR
    export CORE_ROOT=~/products/$selection
    export SWISDK=~/products/$selection
    export SWISRSDK=~/products/$selection
    export SWILicenseServerList="27000@ac-albatross:27000@juelich:27000@ac-birdie"
    echo "$selection was successfully configured on Aachen Windows."
elif [ "$PLATFORM" == 'aachen_linux' ]
then
    . ~/bin/addlibpath.sh /u_grid/ac-green/llu/osr/$selection/lib
    . ~/bin/addpath.sh /u_grid/ac-green/llu/osr/$selection/bin
    export PRODUCT_LIB_PREFIX=SR
    export CORE_ROOT=/u_grid/ac-green/llu/osr/$selection
    export SWISDK=/u_grid/ac-green/llu/osr/$selection
    export SWISRSDK=/u_grid/ac-green/llu/osr/$selection
    export SWILicenseServerList="27000@ac-albatross:27000@juelich:27000@ac-birdie"
    echo "$selection was successfully configured on Aachen Linux."
elif [ "$PLATFORM" == 'burlington_linux' ]
then
    . ~/bin/addlibpath.sh /scratch/res/scratch3/llu/osr/$selection/lib
    . ~/bin/addpath.sh /scratch/res/scratch3/llu/osr/$selection/bin
    export PRODUCT_LIB_PREFIX=SR
    export CORE_ROOT=/scratch/res/scratch3/llu/osr/$selection
    export SWISDK=/scratch/res/scratch3/llu/osr/$selection
    export SWISRSDK=/scratch/res/scratch3/llu/osr/$selection
    export SWILicenseServerList="27000@beeblebrox.speechworks.com:27000@gargravarr.speechworks.com:27000@asia2.pb.scansoft.com"
    echo "OSR $selection was successfully configured on Burlington Linux."
elif [ "$PLATFORM" == 'home_windows' ]
then
    echo "OSR $selection is unavaible on Home Windows."
else
    echo "Unknown System! Nothing was configured."
fi
