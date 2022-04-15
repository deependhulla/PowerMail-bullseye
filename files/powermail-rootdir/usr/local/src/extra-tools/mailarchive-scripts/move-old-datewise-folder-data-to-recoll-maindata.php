<?php
	error_reporting(0);

## should be without trailing /   (no slash)

###$vmainpath="/archive-mail-data";
$vmainpath="/archive-data/mail-archive-compress";


###boxtype =0 means datewise (2016_03_20)

for($y=2021;$y<2022;$y++)
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
$dfolder=$y."-".$mm."-".$dd;
#print "\n Work  $mailfolder ";
$mainbox=$vmainpath."/".$mailfolder."/maindata/12";
mkdir($mainbox, 0777, true);
$cmdx=" mv /archive-data/oldarchivedata/mail-server-5-storage-archive/".$dfolder." ".$mainbox."";
$cmdx=" mv /archive-data/oldarchivedata/mail-archive-compress-data/2021/".$dfolder." ".$mainbox."";
$cmdx=" mv /archive-data/oldarchivedata/mail-archive-compress-data/newformat/".$dfolder." ".$mainbox."";
print "\n $cmdx";
## day loop
}
## mon loop
}
## year loop
}

print "\n";

?>
