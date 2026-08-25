# bug 1. final results as *.zip files are deleted by wrong
# bug 2. folders containing space cannot be correctly parsed.

use File::Find;
use File::Copy;
use Cwd;

if ($ARGV[0] =~ m|^\s*$|)
{
    print "Rename warez directories.\n";
    print "Usage: perl $0 TOP_DIR\n";
    print "Example: perl $0 /temp/my0day\n";
    exit 0;
}

@dirs = glob "$ARGV[0]/*";

foreach $dir (@dirs)
{
    $org = $dir;
    $dir =~ s|\.| |g;
    $dir =~ s|_| |g;
    $dir =~ s|/||g;
    $dir =~ s|Wiley (Interscience)?||g;
    $dir =~ s|Wiley (IEEE Press)?||g;
    $dir =~ s|eBook-.*$||g;
    $dir =~ s|ebook-.*$||g;
    $dir =~ s|(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec) 200\d||g;
    $dir =~ s|^\s+||;
    $dir =~ s|\s+$||;
    print "$dir\n";
    rename $org, "p{Wiley} t{$dir}";
}

