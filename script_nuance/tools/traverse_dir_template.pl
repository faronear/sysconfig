use File::Find;
use File::Copy;

if ($ARGV[0] =~ m|^\s*$|)
{
    print "Template to traverse a directory recursively.\n";
    print "Usage: perl $0 TOP_DIR\n";
    print "Example: perl $0 /bin\n";
    exit 0;
}

@dirs = ($ARGV[0]);

find ( {wanted => \&wanted},
       @dirs );

sub wanted
{
    if (m|^ulaw$|)  # check the current file name, if it contains ulaw then dome something on it.
    {
	$file = $_;
	# do something here.
    }
}

