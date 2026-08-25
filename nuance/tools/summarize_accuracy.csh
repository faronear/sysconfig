#!/bin/csh

# Example: ~/bin/tools/summaryize_accuracy.csh ~/OSR_accuracy/en.sg/results/20060418_osr309 ~/mysum309

if ("$1" == '') then
    echo "Where is the evaluation results directory?"
    echo -n "Please enter an absolute directory: "
    set resdir=$<
else
    set resdir=$1
endif 

# You can enter a path with file name prefix,
# or just enter and the $resdir will be used by default.
if ("$2" == '') then
    echo "Where to save summary files?"
    echo -n "Please enter a absolute path with summary file prefix: "
    set summary=$<
    if ("$summary" == '') then
	set summary=$resdir/summary
    endif
else
    set summary=$2
endif

# overall summary
cd /users/llu/scratch/OSR_accuracy/en.sg; perl ../summarize_proton.pl -normalizeCpu -printinvocab -useGroup proton -meanByWords -meanByTestset -geomMean test $resdir >! $summary.sum; echo Generated $summary.sum

# wer summary
cd /users/llu/scratch/OSR_accuracy/en.sg; perl ../proton_wer.pl -normalizeCpu -printinvocab -useGroup proton -meanByWords -geomMean test $resdir >! $summary.wer; echo Generated $summary.wer

perl ~/bin/tools/convert_summary_for_excel.pl $summary.sum; echo Generated $summary.sum.excel
