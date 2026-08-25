print "Usage: perl $0 transcription_file path_prefix output_file\n";
print "Example: perl $0 /direct/datadigest/en_sg/ives/000.txt /direct/datadigest/en_sg/ives/calls/ ~/ives.list\n";

open TRAN, $ARGV[0] or die "Cannot open transcription file $ARGV[0] for read.\n";
open CORPUS, ">>$ARGV[2]" or die "Cannot open corpus file $ARGV[1] for write.\n";

if ($ARGV[1] =~ m|/$|) # the parameter "path_prefix" is ended with /
{
    $prefix = $ARGV[1];
}else
{
    $prefix = "$ARGV[1]/";
}

while (<TRAN>)
{
    chomp;
    m|([^ ]+)\s+(.*)|;
    if ($1 =~ m|\.info$|) 
    {
	print CORPUS "new_speaker\n";
	next; 
    }
    print CORPUS "$prefix$1.ulaw\t$2\n";
}
