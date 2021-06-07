use File::Find;
use File::Copy;

@files = glob "$ARGV[0]/*";

open XML, ">Favorites.html" or die;
#print XML "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<resource>\n";

foreach $file (@files)
{
    if (-f $file)
    {
	open URL, "$file" or die;
	$url = '';
	while (<URL>)
	{
	    if (m|URL=(.*)|)
	    {
		$url = $1;
		last;
	    }
	}
	$file =~ s|Favorites/||;
	$file =~ s|\.url||;
	$url =~ s|&|&amp;|g;
	print XML "<a href=\"$url\">$file</a><br>\n";
	close URL;
    }
}

#print XML "</resource>\n</xml>\n";
