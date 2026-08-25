#!/bin/csh

if ("$1" == '') then
    echo "Please enter the first absolute path with file prefix:"
    set first=$<
else
    set first=$1
endif

if ("$2" == '') then
    echo "Please enter the second absolute path with file prefix:"
    set second=$<
else
    set second=$2
endif

if ("$3" == '') then
    echo "Please enter the absolute path with file prefix of diff results:"
    set diff=$<
else
    set diff=$3
endif

perl /users/llu/scratch/OSR_accuracy/diff_osr_sum.pl $first.sum $second.sum >! $diff.sum
echo "$first.sum vs. $second.sum => $diff.sum"
perl /users/llu/scratch/OSR_accuracy/diff_osr_wer.pl $first.wer $second.wer >! $diff.wer
echo "$first.wer vs. $second.wer => $diff.wer"
