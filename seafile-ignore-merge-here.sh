#!/bin/bash

echo ::*** Merge remote [seafile-ignore.global.txt] and local [seafile-ignore.local.txt] to [seafile-ignore.txt]
curl -sSL https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/seafile-ignore.global.txt > seafile-ignore.txt
if [ -f seafile-ignore.local.txt ]; then cat seafile-ignore.local.txt >> seafile-ignore.txt; fi
echo
