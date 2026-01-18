#!/bin/bash

echo ::*** Merge remote [.gitignore_global] and local [.gitignore.local.txt] to [.gitignore]
curl -sSL https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/.gitignore_global > .gitignore
if [ -f .gitignore.local.txt ]; then cat .gitignore.local.txt >> .gitignore; fi;
echo
