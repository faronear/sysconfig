print "Usage: perl $0 transcription_dir path_prefix output_file\n";
print "Example: perl $0 /direct/datadigest/read_English_SG/gitm/transcription /direct/datadigest/read_English_SG/gitm/calls/ ~/gitm.list\n";

use File::Find;
use File::Copy;

open CORPUS, ">$ARGV[2]" or die "Cannot open corpus file $ARGV[1] for write.\n";

if ($ARGV[1] =~ m|/$|) # the parameter "path_prefix" is ended with /
{
    $prefix = $ARGV[1];
}else
{
    $prefix = "$ARGV[1]/";
}

@dirs = ($ARGV[0]);

find ( {wanted => \&wanted},
       @dirs );

sub wanted
{
    if (m|^([a-zA-Z0-9_]+)_(utt\d+)\.words$|)
    {
	$folder = $1;
	$utt = $2;
	$folder =~ m|^[A-Za-z]+(\d\d\d)|;
	$group = $1; # usually it's 000, but not always. So $group need be extracted.
	open WORDS, "$_" or die "Cannot open words file $_\n";
	$words = <WORDS>;
	chomp ($words);
	print CORPUS "$prefix$group/$folder/${folder}_${utt}.ulaw\t$words\n";
    }
}
