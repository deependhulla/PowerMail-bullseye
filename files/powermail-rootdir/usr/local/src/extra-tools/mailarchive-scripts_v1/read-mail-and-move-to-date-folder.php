<?php
	error_reporting(0);

## should be without trailing /   (no slash)

###$vmainpath="/archive-mail-data";
$vmainpath="/mail-archive-compress";


###boxtype =0 means datewise (2016_03_20)
###boxtype =1 means monthwise (2016_03)
###boxtype =2 means yearwise (2016)

$boxtype=1;

$make_header_only_for_search=0;

$path = $argv[1];
$path=str_replace("\n","",$path);
$path=str_replace("\t","",$path);
$path=str_replace("\r","",$path);
$path=str_replace("\0","",$path);

#echo mime_content_type($path);
#print "\n";
$ex=array();
$ex =explode(".",$path);
$gotgzip=0;
if(mime_content_type($path) =="application/x-gzip"){$gotgzip=1;}
if($ex[1] == "gz") {$gotgzip=1;}



if($gotgzip==1)
{
$cmdx ="gzip -d ".$path;
`$cmdx`;
$path=str_replace(".gz","",$path);
}

print "\nReading : $path ";
##require_once '/opt/archive-tools/program/vendor/autoload.php';
require_once '/usr/local/src/mailarchive-scripts/vendor/autoload.php';
$Parser = new PhpMimeMailParser\Parser();
$Parser->setPath($path);

#echo $Parser->getRawHeader('diagnostic-code');

$to = $Parser->getHeader('to');
$from = $Parser->getHeader('from');
$subject = $Parser->getHeader('subject');
$stringHeaders = $Parser->getHeadersRaw();	// Get all headers as a string, no charset conversion
//#print_r($stringHeaders);
//$arrayHeaders = $Parser->getHeaders();		// Get all headers as an array, with charset conversion
//print_r($arrayHeaders);
//dummy date for boolean so that first recv header is checked else date (when its sent item no recv date)
$maildatey = DateTime::createFromFormat( 'D, d M Y H:i:s O', $maildatex);



if(gettype($maildatey)=='boolean'){
$rheader = $Parser->getHeader('received');
$dx=array();$dx=explode("; ",$rheader);$maildatex=$dx[1];$dx=array();$dx=explode(" -",$maildatex);$maildatex=$dx[0];
$dzx=array();$dzx=explode(" (",$maildatex);$maildatex=$dzx[0];$maildatey = DateTime::createFromFormat( 'D, d M Y H:i:s O', $maildatex);
$zdzx=array();$zdzx=explode(", ",$maildatex);if( sizeof($zdzx) >1){$maildatex=$zdzx[1];}
if(gettype($maildatey)=='boolean'){
$maildatey = DateTime::createFromFormat( 'd M Y H:i:s', $maildatex);
}

if(gettype($maildatey)=='boolean'){
$maildatey = DateTime::createFromFormat( 'd M Y H:i:s O', $maildatex);
}

print "\n DATEX RECV: ->".$maildatex."<-";

}
///////////////////////////////////////


///////////////////////
if(gettype($maildatey)=='boolean'){
$maildatex = $Parser->getHeader('date');
$maildatex = str_replace("  "," ",$maildatex);
$maildatex = str_replace("GMT"," ",$maildatex);
print "\n DATEX ->".$maildatex."<-";
$maildatey = DateTime::createFromFormat( 'D, d M Y H:i:s O', $maildatex);
if(gettype($maildatey)=='boolean'){$maildatey = DateTime::createFromFormat( 'd M Y H:i:s O', $maildatex);}
if(gettype($maildatey)=='boolean'){$maildatey = DateTime::createFromFormat( 'D d M Y H:i:s O', $maildatex);}
if(gettype($maildatey)=='boolean'){$maildatey = DateTime::createFromFormat( 'd M Y H:i:s O', $maildatex);}

if(gettype($maildatey)=='boolean'){$dx=array();$dx=explode("-",$maildatex);$maildatex=$dx[0];$dx=array();
$dx=explode(",",$maildatex);$maildatex=$dx[1];$maildatey = DateTime::createFromFormat( ' d M Y H:i:s ', $maildatex);}

if(gettype($maildatey)=='boolean'){$maildatey = DateTime::createFromFormat( 'D d M Y H:i:s O', $maildatex);}

if(gettype($maildatey)=='boolean'){$dx=array();$dx=explode("+",$maildatex);$maildatex=$dx[0];$dx=array();$dx=explode(",",$maildatex);
$maildatex=$dx[1];$maildatey = DateTime::createFromFormat( ' d M Y H:i:s ', $maildatex);}


print "\n DATEX7 ->".$maildatex."<-";
#print "\n DATEX8 ->".$maildatey."<-";
}
//////////////////////

echo gettype($maildatey), "\n";

$maildate=$maildatey->format( 'Y_m_d');
$mailmon=$maildatey->format( 'Y_m');
$mailyear=$maildatey->format( 'Y');

if(gettype($maildatey)=='boolean'){$maildate=date('Y_m_d'); $mailmon=date('Y_m'); $mailtear=date('Y');}
$mailfolder=$maildate;
if($boxtype==1){$mailfolder=$mailmon;}
if($boxtype==2){$mailfolder=$mailyear;}
print "\n Work & save $maildate --> $mailfolder ";

$datext=date('hi');
$indexbox=$vmainpath."/".$mailfolder."/indexdata/";
$mainbox=$vmainpath."/".$mailfolder."/maindata/".$datext;
$headerbox=$vmainpath."/".$mailfolder."/headerdata/".$datext;
if($make_header_only_for_search==0){$topmainbox=$vmainpath."/".$mailfolder."/maindata/";}
if($make_header_only_for_search==1){$topmainbox=$vmainpath."/".$mailfolder."/headerdata/";}

mkdir($indexbox, 0777, true);
mkdir($mainbox, 0777, true);
if($make_header_only_for_search==1){mkdir($headerbox, 0777, true);}
$configfile=$indexbox."/recoll.conf";
$topline="topdirs = ".$topmainbox."\n";
file_put_contents($configfile, $topline);

// wait for 2 seconds
//usleep(2000000);
//usleep(1);

$mtime=microtime(true);
$newfile=$mainbox."/".$mtime;
$hfile=$headerbox."/".$mtime;

print "\n Header : $hfile";

if($make_header_only_for_search==1){
file_put_contents($hfile, $stringHeaders);
$mcmdx="gzip -9v \"".$hfile."\" ;  ";
print "\n $mcmdx ";
`$mcmdx`;
}

$mcmdx="mv \"".$path."\" \"".$newfile."\" ; gzip -9v \"".$newfile."\" ; chmod 755 \"".$newfile.".gz\" ;  ";
print "\n $mcmdx ";
`$mcmdx`;

if($make_header_only_for_search==0){$addcmdx="recollindex -c ".$indexbox."/ -i ".$newfile.".gz";}
if($make_header_only_for_search==1){$addcmdx="recollindex -c ".$indexbox."/ -i ".$hfile.".gz";}
print "\n $addcmdx ";
`$addcmdx`;

$searchline="recoll  -t  -c  ".$indexbox."/ -q \"$to\"";
#print "\n$searchline\n";

#print "\n";

?>
