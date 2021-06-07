open UTD, "$ARGV[0]" or die;

$nr_utt = 0;

$nr_block = 0;

$head = "";

while (<UTD>)
{
    if (not m|/datadigest/|)
    {
	$head = $head."$_";
    }else
    {
	if ($nr_utt % 500 == 0)
	{
	    $nr_block ++;
	    open FH, ">$ARGV[0].$nr_block" or die;
	    print FH $head;
	}
	print FH;
	$nr_utt ++;
    }
}
