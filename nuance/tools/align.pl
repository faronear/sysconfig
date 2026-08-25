#!C:/Perl/bin/perl

if ($#ARGV==-1) {
    printf "Usage: align.pl binary_alignment_filename\n";
    exit (0);
};

system ("align_info -labels %SWISRSDK%/config/en.sg/models/SpeechPearl.hmmlabels $ARGV[0] > $ARGV[0].txt");
printf ("$ARGV[0] -> $ARGV[0].txt\n");

open(BINARY_ALIGN, "$ARGV[0].txt") or die "Cannot open file $ARGV[0].txt";

$count=1;

while(<BINARY_ALIGN>){

    s/\s+$//;

    if(/^uttname: $1/){
	close FD;
	$lola = sprintf("alignments_%d.txt", $count++); 
	print "$' => $lola\n";
	open(FD, ">$lola") || die "cannot open $lola";
	printf FD "$'\n";
	printf FD "MillisecondsPerFrame: 10\nEND OF HEADER\n";
	printf FD "start end   phoneme                  score     -sscore score/msec\n";
	$total_score=0;
    } elsif (/^ortho: /){
	printf FD "$'\n";
    } elsif(/^ label index (.*)/){
	$label=$1;
    } elsif (/^ model score (.*)/){
	$score=$1;
	$total_score += $score;
    } elsif (/^ from time (.*)/){
	$from_time=$1;
    } elsif (/^ to time (.*)/){
	$to_time=$1;
    } elsif (/^ segment type (.*)/){
	if (0){
	    next if $from_time == $to_time;
	    printf FD "%5.3f %5.3f %-20s %10.2f %10.2f %.2f\n", $from_time*100, $to_time*100, $label,$score, -$total_score, $score/($to_time -$from_time)/100;
	} else {
	    $dscore = ($to_time==$from_time) ? 0 : $score/($to_time -$from_time)/1000;
	    printf FD "%5.3f %5.3f %-20s %10.2f %10.2f %.2f\n", $from_time, $to_time, $label,$score, -$total_score, $dscore;
	}
    }
}

exit 0;
