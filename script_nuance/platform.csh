#!/bin/csh

set PLATFORM=`hostname | perl -ne 'if (/AC-/) {exec "echo aachen_linux"} elsif (/ac-llu/) {exec "echo aachen_windows"} elsif (/ac-nb-llu/) {exec "echo aachen_windows"} elsif (/xena|cvshost|bn-|wa-|grid-/) {exec "echo burlington_linux"} elsif (/neptune/) {exec "echo home_windows"} else {exec "echo unknown"}'`
# it must return some non-empty string for unknown hostnames, 
# otherwise it makes if statement be wrong for unknown hostnames:
# if ($PLATFORM == 'somename')
# when $PLATFORM is empty string, there would be nothing to the left of ==.
