#!/bin/csh

source ~/bin/platform.csh

if ("$1" == '') then
    echo "Which OSR?"
    echo -n "Please enter an OSR version, e.g. osr309: "
    set selection=$<
else
    set selection=$1
endif 

# todo: check existence of osr installation!
if ("$PLATFORM" == 'aachen_windows') then 
    source ~/bin/addpath.csh ~/products/$selection/bin
    setenv PRODUCT_LIB_PREFIX SR
    setenv CORE_ROOT ~/products/$selection
    setenv SWISDK ~/products/$selection
    setenv SWISRSDK ~/products/$selection
    setenv SWILicenseServerList "27000@ac-albatross:27000@juelich:27000@ac-birdie"
    echo "OSR $selection was successfully configured on Aachen Windows."
else if ("$PLATFORM" == 'aachen_linux') then
    source ~/bin/addlibpath.sh /u_grid/ac-green/llu/osr/$selection/lib
    source ~/bin/addpath.csh /u_grid/ac-green/llu/osr/$selection/bin
    setenv PRODUCT_LIB_PREFIX SR
    setenv CORE_ROOT /u_grid/ac-green/llu/osr/$selection
    setenv SWISDK /u_grid/ac-green/llu/osr/$selection
    setenv SWISRSDK /u_grid/ac-green/llu/osr/$selection
    setenv SWILicenseServerList "27000@ac-albatross:27000@juelich:27000@ac-birdie"
    echo "OSR $selection was successfully configured on Aachen Linux."
else if ("$PLATFORM" == 'burlington_linux') then
    source ~/bin/addlibpath.csh /scratch/res/scratch3/llu/osr/$selection/lib
    source ~/bin/addpath.csh /scratch/res/scratch3/llu/osr/$selection/bin
    setenv PRODUCT_LIB_PREFIX SR
    setenv CORE_ROOT /scratch/res/scratch3/llu/osr/$selection
    setenv SWISDK /scratch/res/scratch3/llu/osr/$selection
    setenv SWISRSDK /scratch/res/scratch3/llu/osr/$selection
    setenv SWILicenseServerList "27000@beeblebrox.speechworks.com:27000@gargravarr.speechworks.com:27000@asia2.pb.scansoft.com"
    echo "OSR $selection was successfully configured on Burlington Linux."
else if ("$PLATFORM" == 'home_windows') then
    echo "OSR $selection is unavaible on Home Windows."
else
    echo "Unknown System! Nothing was configured."
endif
