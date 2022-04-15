<?php

$folderx="/home/powermail/domains/".$argv[1]."/".$argv[2]."/";
print $argv[2]."@".$argv[1]."|";
$rf=$folderx."/subscribers/";

$cmdx="find ".$rf." -type f";
$outx=`$cmdx`;
$filex=array();
$filex=explode("\n",$outx);
$listx="";
for($f=0;$f<sizeof($filex);$f++)
{
if($filex[$f]!="")
{
#echo "\n Read file : ".$filex[$f];
$fd=file_get_contents($filex[$f]);
$fd=str_replace("\n","",$fd);
$fd=str_replace("\r","",$fd);
$fd=str_replace("\t","",$fd);
$fd=str_replace("\0","",$fd);
$fd=str_replace(" ","",$fd);
$fd=str_replace("T",",",$fd);
if($fd!=""){$listx=$listx.$fd;}
#print "\n $fd";
}
}

#print "$listx";
$emailx=array();
$emailx=explode(",",$listx);
$ee=0;
for($e=0;$e<sizeof($emailx);$e++)
{
if($emailx[$e]!="")
{
if($ee!=0){print ",";}
$ee++;
print "".$emailx[$e]."";
}
}

print "|";


?>
<?php

$folderx="/home/powermail/domains/".$argv[1]."/".$argv[2]."/";

$rf=$folderx."/mod/subscribers/";

$cmdx="find ".$rf." -type f";
$outx=`$cmdx`;
$filex=array();
$filex=explode("\n",$outx);
$listx="";
for($f=0;$f<sizeof($filex);$f++)
{
if($filex[$f]!="")
{
#echo "\n Read file : ".$filex[$f];
$fd=file_get_contents($filex[$f]);
$fd=str_replace("\n","",$fd);
$fd=str_replace("\r","",$fd);
$fd=str_replace("\t","",$fd);
$fd=str_replace("\0","",$fd);
$fd=str_replace(" ","",$fd);
$fd=str_replace("T",",",$fd);
if($fd!=""){$listx=$listx.$fd;}
#print "\n $fd";
}
}

#print "$listx";
$emailx=array();
$emailx=explode(",",$listx);
$ee=0;
for($e=0;$e<sizeof($emailx);$e++)
{
if($emailx[$e]!="")
{
if($ee!=0){print ",";}
$ee++;
print "".$emailx[$e]."";
}
}

print "\n";


?>
