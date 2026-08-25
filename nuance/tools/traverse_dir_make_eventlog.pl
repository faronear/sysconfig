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

open LOG, ">$ARGV[0]/SWIevent.log" or die;

$time='20060101000000000';
$defaultdm='Digits';
$grammar='digits.xml';
$language='en-GB';
$meaning='0';
$ortho='';

find ( {wanted => \&wanted},
       @dirs );

sub wanted
{
    if (/\.(ulaw|wav)$/)
    {
	$file = $_;
	print LOG "TIME=$time|CHAN=0|EVNT=SWIclst|UCPU=0|SCPU=0\n";
	print LOG "TIME=$time|CHAN=0|EVNT=SWIdmst|DMTP=CUST|DMNM=$defaultdm|UCPU=0|SCPU=0\n";
	print LOG "TIME=$time|CHAN=0|EVNT=SWIrcst|GURI0=$grammar|GRNM=$grammar|LANG=$language|GRMT=application/srgs+xml|UCPU=0|SCPU=0\n";
	print LOG "TIME=$time|CHAN=0|EVNT=SWIrcnd|RSTT=ok|RSLT=$meaning|RAWT=$ortho|SPOK=$ortho|GRMR=GURI0|CONF=999|WVNM=$file|UCPU=0|SCPU=0\n";
	print LOG "TIME=$time|CHAN=0|EVNT=SWIdmnd|TSTT=Success|UCPU=0|SCPU=0\n";
	print LOG "TIME=$time|CHAN=0|EVNT=SWIclnd|UCPU=0|SCPU=0\n";
    }
}

