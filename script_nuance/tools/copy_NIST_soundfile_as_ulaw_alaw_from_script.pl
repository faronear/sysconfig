$scriptfile = $ARGV[0];
open (SCR, $scriptfile);
while(<SCR>)
{
	chomp($_);
	$_ =~ s/ +$//;
	$startwriting = 0;
	if(($_ =~ /^recognize/)&&($_ =~ /\.wav/))
	{
		@parts = split(/ /, $_);
		$soundFile = $parts[1];
		open(WAV,$soundFile) || next;
# die "cannot open $soundFile: $1";
#                open(WAV,$soundFile) || die;
		binmode WAV;
	
		# get first 4 Bytes
		read WAV,$rawstring, 4;
		$signature = unpack("a4",$rawstring);
	
		if ($signature eq "NIST")
		{
	    	print "$soundFile has a sphere header and is converted to ulaw!\n";
			$input = $soundFile;
			$input_base = substr($input, 0 ,-4);
			open (INPUT, $input);
			binmode INPUT;
			while ($line = <INPUT>)
			{
				if($startwriting == 1)
				{
					$line =~ s/^ +//; #remove rest of header (spaces)
					$startwriting = 2;
					$output = $input_base . ".". $ext;
					open(OUTPUT, ">". $output) or die;
					binmode OUTPUT;
				}
				elsif($startwriting == 2)
				{
					print OUTPUT $line;
				}
				elsif($line =~ /end_head/)
				{
					$startwriting = 1; #read lines until end_head statement is found.
				}
				else
				{
					if($line =~ /s4 alaw/)
					{
						$ext = "alaw";
						print $ext."\n";	
					}
					elsif($line =~ /s4 ulaw/)
					{
						$ext = "ulaw";
						print $ext."\n";	
					}
				}
			}
		}
	}
}
