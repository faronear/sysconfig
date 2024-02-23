#!/bin/bash

echo === Merge remote [.gitignore_global] and local [.gitignore_local] to [.gitignore] ===
curl -sSL https://git.faronear.org/npm/sysconfig/raw/branch/main/nixhome/.gitignore_global > .gitignore
if [ -f .gitignore_local ]; then cat .gitignore_local >> .gitignore; fi;
echo
