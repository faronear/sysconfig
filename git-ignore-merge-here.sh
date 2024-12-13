#!/bin/bash

echo #<<< Merge remote [.gitignore.global.txt] and local [.gitignore.local.txt] to [.gitignore]
curl -sSL https://git.faronear.org/npm/sysconfig/raw/branch/main/nixhome/.gitignore.global.txt > .gitignore
if [ -f .gitignore.local.txt ]; then cat .gitignore.local.txt >> .gitignore; fi;
echo
