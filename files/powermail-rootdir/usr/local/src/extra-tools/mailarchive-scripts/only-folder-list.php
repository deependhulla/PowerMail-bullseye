<?php

$vmainpath="/archivedata/mail-archive-compress";


###boxtype =0 means datewise (2016_03_20)
###boxtype =1 means monthwise (2016_03)
###boxtype =2 means yearwise (2016)

for($y=2011;$y<2022;$y++)
{
for($m=1;$m<13;$m++)
{
$mm=$m;
if($m<10){$mm="0".$m;};
$mailfolder=$y."_".$mm;
#print "\n $mailfolder";
$datext=date('hi');
$indexbox=$vmainpath."/".$mailfolder."/indexdata/";
$mainbox=$vmainpath."/".$mailfolder."/maindata/".$datext;
$headerbox=$vmainpath."/".$mailfolder."/headerdata/".$datext;
$topmainbox=$vmainpath."/".$mailfolder."/maindata/";

mkdir($indexbox, 0777, true);
mkdir($mainbox, 0777, true);
$configfile=$indexbox."/recoll.conf";
$topline="topdirs = ".$topmainbox."\n";
$topline=$topline."indexedmimetypes = application/gzip text/html message/rfc822\n";
$topline=$topline."nocjk = false\n";
$topline=$topline."pdfocr = false\n";
$topline=$topline."pdfattach = false\n";
$topline=$topline."indexstemminglanguages = english\n";
#file_put_contents($configfile, $topline);

#$cmdx="mv /archivedata/oldarchivedata/mail-server-5-storage-archive/".$y."-".$mm."-* ".$topmainbox;
#print "\n ".$cmdx;
#`$cmdx`;
$cmdx="recollindex -c ".$indexbox;
print $cmdx."\n";
##########
}
}
?>
