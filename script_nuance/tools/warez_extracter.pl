# bug 1. final results as *.zip files are deleted by wrong
# bug 2. folders containing space cannot be correctly parsed.

use File::Find;
use File::Copy;
use Cwd;

if ($ARGV[0] =~ m|^\s*$|)
{
    print "Extract warez directories recursively.\n";
    print "Usage: perl $0 TOP_DIR\n";
    print "Example: perl $0 /temp/my0day\n";
    exit 0;
}

@dirs = ($ARGV[0]);

find ( {wanted => \&wanted},
       @dirs );

sub wanted
{
    if (-d $_)
    {
	# We are in the containing folder of $_
	$folder = $_;
	$folder =~ s| |_|g; # folders containing space in names cannot be extracted.
	rename $_, $folder;

	@zipfiles = glob "$folder/*.zip";
	foreach $zipfile (@zipfiles)
	{
	    print "$zipfile\n";
	    system "unzip -n $zipfile -d $folder";
	}

	@rarfiles = glob "$folder/*.rar";
	if (scalar @rarfiles > 0)
	{
	    $rarfile = $rarfiles[0]; # Only the first rar (which is the sole *.rar or *.part1.rar) is to be extracted. 
	    print "$rarfile\n";
	    system "\"s:/Program Files/WinRAR/RAR.exe\" x -o- $rarfile $folder > $folder/unrar.info";
	}

	#############################
	##### WARNING ###############
	# sometime a file extracted from *.rar is another *.zip! In this case it will be deleted by wrong!
	open INFO, "$folder/unrar.info" or next;
	while (<INFO>)
	{
	    if (m|All OK|)
	    {
		unlink glob "$folder/*.zip";
		unlink glob "$folder/*.r??";
		unlink glob "$folder/*.DIZ";
		unlink glob "$folder/*.diz";
		unlink glob "$folder/unrar.info";
	    }
	}
	close INFO;
   }
}
