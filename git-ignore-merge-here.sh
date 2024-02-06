#!/bin/bash

echo === Merge [.gitignore_global] and [.gitignore_local] to [.gitignore] ===
curl -sSL https://git.faronear.org/npm/sysconfig/raw/branch/main/nixhome/.gitignore_global > .gitignore && cat .gitignore_local >> .gitignore
echo
