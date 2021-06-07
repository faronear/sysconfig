if ($ARGV[0] =~ m|^\s*$|)
{
    print "Check existence of listed sound files.\n";
    print "Usage: perl $0 FILE_LIST\n";
    print "Example: perl $0 corpus.list\n";
    exit 0;
}

open LIST, "$ARGV[0]" or die;

open REPORT, ">$ARGV[0].inexistent" or die;

while (<LIST>)
{
    if (m|\s*([^\s]+\.(ulaw\|wav))\s*|)
    {
	if (not (-e $1))
	{
	    print REPORT "$1\n";
	}
    }
}
