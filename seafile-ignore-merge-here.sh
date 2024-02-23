#!/bin/bash

echo === Merge remote [seafile-ignore_global] and local [seafile-ignore_local] to [seafile-ignore.txt] ===
curl -sSL https://git.faronear.org/npm/sysconfig/raw/branch/main/nixhome/seafile-ignore_global > seafile-ignore.txt
if [ -f seafile-ignore_local ]; then cat seafile-ignore_local >> seafile-ignore.txt; fi
echo
