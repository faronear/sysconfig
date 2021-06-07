open SCRIPT, "$ARGV[0]" or die;
open XML, ">$ARGV[0].xml" or die;

print XML <<xmlhead;
<?xml version="1.0" encoding='UTF-8'?>
<grammar xml:lang="de-DE" version="1.0" root="_ROOT" xmlns="http://www.w3.org/2001/06/grammar">
  <rule id="_ROOT" scope="public">
    <ruleref uri="#ITEMS"/>
    <tag>SWI_meaning = ITEMS.V;</tag>
  </rule>
  <rule id="ITEMS">
    <one-of>
xmlhead

while (<SCRIPT>)
{
    if (m|^transcription\s+(.*)\s*$|)
    {
	$items{$1} ++;
    }
}

foreach $item (keys %items)
{
    print XML "      <item>$item<tag>V=\"$item\"</tag></item>\n";
}

print XML <<xmltail;
    </one-of>
  </rule>
</grammar>
xmltail
