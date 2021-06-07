#!/bin/bash 

# Usage: this_script target_dir

for zipfile in $1/*.zip; do
unzip -n $zipfile -d $1;
done

for rarfile in $1/*.rar; do
/cygdrive/s/Program\ Files/WinRAR/RAR.exe x -o- $rarfile $1;
done

rm -f *.DIZ
rm -f *.diz

