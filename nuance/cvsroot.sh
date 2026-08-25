#!/bin/bash

if [ "$1" == '' ]
then
    echo "Which CVSROOT?"
    echo " p for Product at :pserver:llu@cvshost.speechworks.com:/swicvs/product"
    echo " s for Solutions at :pserver:llu@cvshost.speechworks.com:/swicvs/solutions"
    echo " a for AMR at :pserver:llu@wa-csr-cvs.wa.scansoft.com:/res/lvcsr/code/cvsroot"
    echo " o for Office at :ext:llu@ac-llu.nuance.com:/cygdrive/c/Home/cvsrep"
    echo " h for Home at :ext:llu@nil.sytes.net:/cygdrive/r/cvsrep"
    echo -n ":"
    read selection
else
    selection=$1
fi

case $selection in
    p) export CVSROOT=":pserver:llu@cvshost.speechworks.com:/swicvs/product"
	echo "CVSROOT of Product was successfully configured.";;
    s) export CVSROOT=":pserver:llu@cvshost.speechworks.com:/swicvs/solutions"
	echo "CVSROOT of Solution was successfully configured.";;
    a) export CVSROOT=":pserver:llu@wa-csr-cvs.wa.scansoft.com:/res/lvcsr/code/cvsroot"
	echo "CVSROOT of AMR was successfully configured.";;
    o) export CVSROOT=":ext:llu@ac-llu.nuance.com:/cygdrive/c/Home/cvsrep"
	echo "CVSROOT of Office was successfully configured.";;
    h) export CVSROOT="ext:llu@nil.sytes.net:/cygdrive/r/cvsrep"
	echo "CVSROOT of Home was successfully configured.";;
    *) echo "Unknown option! Nothing was configured."
	echo "Usage: . cvsroot.sh [psaoh]"
	echo "Example: . ~/bin/cvsroot.sh o";;
esac
