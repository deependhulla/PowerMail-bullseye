<?php

## file should have user-email-address,email-password per line
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
if($u==1){
$dux=array();
$dux=explode("@",$ux[0]);

$cmdx="/home/powermail/bin/vadddomain ".$dux[1]."" ;print "$cmdx";
print "\n";
}
$cmdx="/home/powermail/bin/vadduser ".$ux[0]." \"".$ux[2]."\"" ;print "$cmdx";
print "\n";
$cmdx="/home/powermail/bin/vsetuserquota ".$ux[0]." \"".$ux[1]."\"" ;print "$cmdx";

print "\n";
}
}

print "\n";
?>

