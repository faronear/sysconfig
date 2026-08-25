#####################################################################################################################################
# Script to remove DM-related tokens that cause log not to load into OSI due to max nested levels.
# The SWIdmst and SWIphnd tokens will be replaced with SWIprst to print the relevant information
#####################################################################################################################################

#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my ($help, $inputfile, $outputfile);
GetOptions ('-help' => \$help, 
			 '-h' => \$help,
			 '-input=s' => \$inputfile,
			 '-output=s' => \$outputfile
	    );

if ($help) {
	die("\nUsage: perl $0 [-help] -input <i/p file> -output <o/p file> \n"); }
if ($inputfile eq "" || $outputfile eq "" ) {
	die("\nUsage: perl $0 [-help] -input <i/p file> -output <o/p file> \n"); }


open( INPUT_FILE, "< $inputfile" )									#open input file for reading;
		or die( "Cannot open input file \"$inputfile\" : $!" );
open( OUTPUT_FILE, ">$outputfile" )									#open output file  for writing;
		or die( "Cannot open output file \"$outputfile\" : $!");

#my $type = "APNM";
#my $channum = "";
#my $orgchantext = "phone.-1.mps.-1.chan";

	while ( my $string = <INPUT_FILE> ) {
		chomp($string);
#		my $outputstring = $string;
# Replace the Problematic SWIdmst and SWIdmnd with SWIprst to print the relevant information
	if ( $string =~ m/SWIdmst/ || $string =~ m/SWIdmnd/ 
	|| $string =~ m/SWIphst/ || $string =~ m/SWIphnd/
	|| $string =~ m/SWIstst/ || $string =~ m/SWIstnd/) {
#	print ("$string\n" );
	# SWIdmst
		if ( $string =~ m/SWIdmst/ ) {
			$string =~ s/SWIdmst/SWIprst/;
			$string =~ s/DMTP=/PRNM=<DMTP>/;
			$string =~ s/DMNM=/PRTX=<DMNM>/;			
		print (OUTPUT_FILE "$string\n" );
		}
	# SWIphnd - use this instead of SWIdmnd since it has HYPO of DTMF
		if ( $string =~ m/SWIphnd/ ) {
			$string =~ s/SWIphnd/SWIprst/;
			$string =~ s/TSTT=/PRNM=<TSTT>/;
			$string =~ s/MODE=/PRTX=<MODE=/;
		my ($pre, $mid) = split( /\|UCPU/ , $string);
	my ($pre1, $pre2) = split( /MODE/ , $pre);
	$pre2 =~ s/\|/\!/g;
	my $newstring = $pre1."MODE".$pre2.">|UCPU".$mid;		
#		my $newstring = $pre.">|UCPU".$mid;

		print (OUTPUT_FILE "$newstring\n" );
		}	
	# SWIdmnd
#		if ( $string =~ m/SWIdmnd/ ) {
#			$string =~ s/SWIdmnd/SWIprst/;
#			$string =~ s/TSTT=/PRNM=<TSTT>/;
#			$string =~ s/TRTT=/PRTX=<TRTT>/;			
#		print (OUTPUT_FILE "$string\n" );
#		}	
	} 
	else {
		print (OUTPUT_FILE "$string\n" );
	}
#endif 

	} #end of WHILE;

#close the Input and Output files;
close( INPUT_FILE )
	or die( "Cannot close \"$inputfile\" : $!" );
close( OUTPUT_FILE )
	or die( "Cannot close \"$outputfile\" : $!" );

print "COMPLETE\n\n\n\n";


#####################################################################################################################################
