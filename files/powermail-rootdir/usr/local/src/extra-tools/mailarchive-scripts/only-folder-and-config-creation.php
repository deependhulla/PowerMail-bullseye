<?php
	error_reporting(0);

## should be without trailing /   (no slash)

###$vmainpath="/archive-mail-data";
$vmainpath="/archive-data/mail-archive-compress";


###boxtype =0 means datewise (2016_03_20)

for($y=2011;$y<2022;$y++)
{
for($m=1;$m<13;$m++)
{
$mm=$m;
if($m<10){$mm="0".$m;}

for($d=1;$d<32;$d++)
{
$dd=$d;
if($d<10){$dd="0".$d;}
$mailfolder=$y."_".$mm."_".$dd;
print "\n Work  $mailfolder ";

$datext=date('hi');
$indexbox=$vmainpath."/".$mailfolder."/indexdata/";
$mainbox=$vmainpath."/".$mailfolder."/maindata/".$datext;
$topmainbox=$vmainpath."/".$mailfolder."/maindata/";
$configfile=$indexbox."/recoll.conf";
$topline="topdirs = ".$topmainbox."\n";
print " \n $indexbox \n $mainbox \n $topmainbox \n";

#mkdir($indexbox, 0777, true);
#mkdir($mainbox, 0777, true);
#mkdir($headerbox, 0777, true);
#file_put_contents($configfile, $topline);

## day loop
}
## mon loop
}
## year loop
}

print "\n";

?>
