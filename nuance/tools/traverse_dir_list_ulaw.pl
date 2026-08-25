use File::Find;
use File::Copy;

if ($ARGV[0] =~ m|^\s*$|)
{
    print "Traverse a directory recursively and list ulaw files.\n";
    print "Usage: perl $0 TOP_DIR\n";
    print "Example: perl $0 /bin\n";
    exit 0;
}

@dirs = ($ARGV[0]);

open LIST, ">$ARGV[0].ulawlist" or die;

find ( {wanted => \&wanted},
       @dirs );

sub wanted
{
    if (m|^ulaw$|)
    {
	$file = $_;
	# do something here.
	print LIST "$file\n";
    }
}
