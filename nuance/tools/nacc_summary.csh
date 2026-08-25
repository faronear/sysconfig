#!/bin/csh

echo "Usage: source nacc_summary.csh lg.co 1st_result_set [2nd_result_set]"

setenv OSRACCDIR /scratch/res/work/Quantum/llu/nacc
setenv CFG $OSRACCDIR/$1/cfg/BASELINE.cfg

perl $OSRACCDIR/script/summarize_proton.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $CFG -output $2/summary.proton proton $2 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $2/summary.proton 
echo Generated $2/summary.proton
perl $OSRACCDIR/script/proton_wer.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $CFG -output $2/summary.wer proton $2 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $2/summary.wer
echo Generated $2/summary.wer

# for variable $3, it doesn't work to use $?3 for test existence.
if ($3 != '') then
    perl $OSRACCDIR/script/summarize_proton.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $CFG -output $3/summary.proton proton $3 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $3/summary.proton
    echo Generated $3/summary.proton
    perl $OSRACCDIR/script/proton_wer.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $CFG -output $3/summary.wer proton $3 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl $3/summary.wer
    echo Generated $3/summary.wer

    perl $OSRACCDIR/script/summarize_proton.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $CFG -output ./compare.summary.proton proton1 $2 proton2 $3 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl ./compare.summary.proton
    echo Generated ./compare.summary.proton
    perl $OSRACCDIR/script/proton_wer.pl -printinvocab -normalizeCpu -runtest proton -useGroup proton -meanByTestset -config $CFG -output ./compare.summary.wer proton1 $2 proton2 $3 > /dev/null; perl ~/bin/tools/convert_summary_for_excel.pl ./compare.summary.wer
    echo Generated ./compare.summary.wer

    perl $OSRACCDIR/script/diff_osr_sum.pl $2/summary.proton $3/summary.proton >! ./diff.summary; perl ~/bin/tools/convert_summary_for_excel.pl ./diff.summary
    echo "Generated ./diff.summary from $2 vs $3 /summary.proton"
    perl $OSRACCDIR/script/diff_osr_wer.pl $2/summary.wer $3/summary.wer >! ./diff.wer; perl ~/bin/tools/convert_summary_for_excel.pl ./diff.wer
    echo "Generated ./diff.wer from $2 vs $3 /summary.wer"
endif
