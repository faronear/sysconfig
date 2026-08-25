#!/bin/csh


if ("$1" == '') then
    echo "Which target?"
    echo " home"
    echo " office for leiqin@leiqin.eu.scansoft.com"
    echo " aachen for leiqin@ac-green.eu.scansoft.com"
    echo " xena for llu@xena.speechworks.com"
    echo " grid for llu@grid-cnh8.grid.nuance.com"
    echo " menlo for lleiqin@navy.nuance.com"
    echo -n ":"
    set selection=$<
else
    set selection=$1
endif

switch ($selection) 
case home: 
    ssh -C -X Administrator@nil.sytes.net
    breaksw
case office:
    ssh -C -X leiqin@leiqin.eu.scansoft.com
    breaksw
case aachen: 
    ssh -C -X leiqin@ac-green.eu.scansoft.com
    breaksw
case xena: 
    ssh -C -X llu@xena.speechworks.com
    breaksw
case grid: 
    ssh -C -X llu@grid-cnh8.grid.nuance.com
    breaksw
case menlo:
    ssh -C -X lleiqin@navy.nuance.com
    breaksw
default:
    echo "Unknown option!"
    ssh -C -X $selection
endsw
