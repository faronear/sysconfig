#!/bin/bash

if [ "$1" == '' ] 
then
    echo "Which target?"
    echo " home"
    echo " office for leiqin@leiqin.eu.scansoft.com"
    echo " aachen for leiqin@ac-green.eu.scansoft.com"
    echo " xena for llu@xena.speechworks.com"
    echo " grid for llu@grid-cnh8.grid.nuance.com"
    echo " menlo for lleiqin@navy.nuance.com"
    echo -n ":"
    read selection
else
    selection=$1
fi

case $selection in
    home) ssh -C -X Administrator@nil.sytes.net;;
    office) ssh -C -X leiqin@leiqin.eu.scansoft.com;;
    aachen) ssh -C -X leiqin@ac-green.eu.scansoft.com;;
    xena) ssh -C -X llu@xena.speechworks.com;;
    grid) ssh -C -X llu@grid-cnh8.grid.nuance.com;;
    menlo) ssh -C -X lleiqin@navy.nuance.com;;
    *) echo Unknown target!
	ssh -C -X $selection;;
esac
