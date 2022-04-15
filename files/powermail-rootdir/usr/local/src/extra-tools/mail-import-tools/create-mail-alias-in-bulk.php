<?php

## file should have alias-email-address|to-email-address-with-comma-seprate
$filein=$argv[1];
$filedata=file_get_contents($filein);

$fileline=explode("\n",$filedata);

for($i=0;$i<sizeof($fileline);$i++)
{
if($fileline[$i]!="")
{
$fileline[$i]=str_replace("&","",$fileline[$i]);
#print "\n --> $i --> ".$fileline[$i];
$ux=array();
$ux=explode("|",$fileline[$i]);
## for powermail
$cmdx="/home/powermail/bin/vaddalias ".$ux[0]." ".$ux[1]."";

## for qmail
#$cmdx="/home/vpopmail/bin/valias -i ".$ux[1]." ".$ux[0]."";

print "$cmdx";
print "\n";
}
}

print "\n";


?>
