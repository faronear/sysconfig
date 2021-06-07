#!/bin/csh

if ("$1" == '') then
    echo "Which CVSROOT?"
    echo " p for Product at :pserver:llu@cvshost.speechworks.com:/swicvs/product"
    echo " s for Solution at :pserver:llu@cvshost.speechworks.com:/swicvs/solutions"
    echo " a for AMR at :pserver:llu@wa-csr-cvs.wa.scansoft.com:/res/lvcsr/code/cvsroot"
    echo " o for Office at :ext:llu@ac-llu.nuance.com:/cygdrive/c/Home/cvsrep"
    echo " h for Home at :ext:llu@nil.sytes.net:/cygdrive/r/cvsrep"
    echo -n ":"
    set selection=$<
else
    set selection=$1
endif

switch ($selection) 
case p: 
    setenv CVSROOT ":pserver:llu@cvshost.speechworks.com:/swicvs/product"
    echo "CVSROOT of Product was successfully configured."
    breaksw
case s: 
    setenv CVSROOT ":pserver:llu@cvshost.speechworks.com:/swicvs/solutions"
    echo "CVSROOT of Solution was successfully configured."
    breaksw
case a: 
    setenv CVSROOT ":pserver:llu@wa-csr-cvs.wa.scansoft.com:/res/lvcsr/code/cvsroot"
    echo "CVSROOT of AMR was successfully configured."
    breaksw
case o: 
    setenv CVSROOT ":ext:llu@ac-llu.nuance.com:/cygdrive/c/Home/cvsrep"
    echo "CVSROOT of Office was successfully configured."
    breaksw
case h:
    setenv CVSROOT ":ext:llu@nil.sytes.net:/cygdrive/r/cvsrep"
    echo "CVSROOT of Home was successfully configured."
    breaksw
default:
    echo "Unknown option! Nothing was configured."
    echo "Usage: . cvsroot.sh [psaoh]"
    echo "Example: . ~/bin/cvsroot.csh o";;
endsw
