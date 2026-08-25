
open(SUM, "$ARGV[0]");
open(EXCEL, ">". "$ARGV[0].excel");

if ($ARGV[0] eq '')
{
    print "Converting summary file $ARGV[0] to excel format.\n";
    print "Usage: perl $0 SUMMARY_FILE\n";
    exit;
}

while(<SUM>)
{
	chomp($_);
	$_ =~ s/^ +//g;
	$_ =~ s/ +$//g;
	$_ =~ s/ +/ /g;
	$_ =~ s/ /\t/g;
	$_ =~ s/%//g;
	print EXCEL $_."\n";
}
