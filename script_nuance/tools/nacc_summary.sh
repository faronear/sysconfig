#!/bin/bash

echo "Usage: source nacc_summary.csh 1st_result_set [2nd_result_set]"

export LLUNACCDIR=/scratch/res/work/Quantum/llu/nacc
export LLUCFG=/scratch/res/work/Quantum/llu/nacc/zh.tw/cfg/BASELINE.cfg

perl $LLUNACCDIR/script/summarize_proton.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $LLUCFG -output $1/summary.proton proton $1 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $1/summary.proton
echo Generated $1/summary.proton
perl $LLUNACCDIR/script/proton_wer.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $LLUCFG -output $1/summary.wer proton $1 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $1/summary.wer
echo Generated $1/summary.wer

if [ ! -z "$2" ]
then
    perl $LLUNACCDIR/script/summarize_proton.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $LLUCFG -output $2/summary.proton proton $2 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $2/summary.proton
    echo Generated $2/summary.proton
    perl $LLUNACCDIR/script/proton_wer.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $LLUCFG -output $2/summary.wer proton $2 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $2/summary.wer
    echo Generated $2/summary.wer

    perl $LLUNACCDIR/script/summarize_proton.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $LLUCFG -output ./compare.summary.proton proton1 $1 proton2 $2 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl ./compare.summary.proton
    echo Generated ./compare.summary.proton
    perl $LLUNACCDIR/script/proton_wer.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $LLUCFG -output ./compare.summary.wer proton1 $1 proton2 $2 >/dev/null; perl ~/bin/tools/convert_summary_for_excel.pl ./compare.summary.wer
    echo Generated ./compare.summary.wer

    perl $LLUNACCDIR/script/diff_osr_sum.pl $1/summary.proton $2/summary.proton >! ./diff.summary; perl ~/bin/tools/convert_summary_for_excel.pl ./diff.summary
    echo "Generated ./diff.summary from $1 vs $2 /summary.proton"
    perl $LLUNACCDIR/script/diff_osr_wer.pl $1/summary.wer $2/summary.wer >! ./diff.wer; perl ~/bin/tools/convert_summary_for_excel.pl ./diff.wer
    echo "Generated ./diff.wer from $1 vs $2 /summary.wer"
fi
