<?php

$filex="got-list.csv";
$domain="yourdomain.com";
$outfile="full-list-".$domain."";
$outfile=str_replace(".","_",$outfile);
$outfile=$outfile.".csv";
$fd=array();
$fdx=file_get_contents($filex);
$fd=explode("\n",$fdx);
$cmdx="echo > ".$outfile;
print "\n $cmdx";
for($f=0;$f<sizeof($fd);$f++)
{
if($fd[$f]!="")
{
#print "\n $f --> ".$fd[$f];
$cmdx="php  export-ezmlm-per-group-all.php ".$domain." ".$fd[$f]." >> ".$outfile;
$outx=`$cmdx`;
print "\n $cmdx";

}
}

print "\n";
?>
