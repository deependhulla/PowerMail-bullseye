<?php

## file should have user-email-address per line
$filein=$argv[1];
$filedata=file_get_contents($filein);

$fileline=explode("\n",$filedata);
$u=0;
for($i=0;$i<sizeof($fileline);$i++)
{
if($fileline[$i]!="")
{
#print "\n --> $i --> ".$fileline[$i];
$ux=array();
$ux=explode(",",$fileline[$i]);
$u++;
$cmdx="/home/powermail/bin/vmarkasother ".$ux[0]." \"other\"" ;print "$cmdx";

print "\n";
}
}

print "\n";
?>

