<?php



## use 01-build-list.sh to call this script
## DO NOT CHANGE IN THIS for SEARCH 
 
## search email is complete email-address for search in From and To.
$search_email_id=$argv[1];

## Search Date is per month  (YYYMM) or date (YYYMMDD)
$searchdate=$argv[2];


#print "\n $search_email_id --> $searchdate";
fwrite(STDERR, "Searching for : $search_email_id --> $searchdate\n");


## Emailarchive search folder
$vmainpath="/mailarchivedata/new-mail-archive-data";
#$vmainpath="/archive-mail-data";
###boxtype =0 means datewise (2016_03_20)
###boxtype =1 means monthwise (2016_03)
###boxtype =2 means yearwise (2016)
$boxtype=1;


## no of fix entry to work example 10 for testing
$noofrec="";
$noofrec=" -n 10000 ";

$searchdate=str_replace("\n","",$searchdate);
$searchdate=str_replace("\t","",$searchdate);
$searchdate=str_replace("\r","",$searchdate);
$searchdate=str_replace(" ","",$searchdate);
$search_email_id=str_replace("\n","",$search_email_id);
$search_email_id=str_replace("\t","",$search_email_id);
$search_email_id=str_replace("\r","",$search_email_id);
$search_email_id=str_replace(" ","",$search_email_id);
$edate=explode("-",$searchdate);
$yearx=$edate[0];
$monx=$edate[1];
$datex=$edate[2];
$foldercheck="";
if($boxtype==2){$foldercheck=$yearx;}
if($boxtype==1){$foldercheck=$yearx."_".$monx;}
if($boxtype==0){$foldercheck=$yearx."_".$monx."_".$datex;}
#print " --> $yearx  --> $monx --> $datex <--";


$flist=array();
$f=0;

## From search --start
$qx="author:".$search_email_id." AND date :".$searchdate." ";
$cmdx="/usr/bin/recoll -t -m ".$noofrec."  -c  ".$vmainpath."/".$foldercheck."/indexdata/ -q \"(".$qx.")\" 2>/dev/null";
#print "\n $cmdx \n";
$cmdoutx=`$cmdx`;
$cmdout=explode("\n",$cmdoutx);
for($e=2;$e<sizeof($cmdout);$e++){$s3=array();$s3=explode(" = ",$cmdout[$e]);
$s3[1]=str_replace("file://","",$s3[1]);if($s3[0] == "url"){$flist[$f]=$s3[1]; $f++;}}
## From search end 


## To search --start
$qx="rcpt:".$search_email_id." AND date :".$searchdate." ";
$cmdx="/usr/bin/recoll -t -m ".$noofrec."  -c  ".$vmainpath."/".$foldercheck."/indexdata/ -q \"(".$qx.")\" 2>/dev/null";
#print "\n $cmdx \n";
$cmdoutx=`$cmdx`;
$cmdout=explode("\n",$cmdoutx);
for($e=2;$e<sizeof($cmdout);$e++){$s3=array();$s3=explode(" = ",$cmdout[$e]);
$s3[1]=str_replace("file://","",$s3[1]);if($s3[0] == "url"){$flist[$f]=$s3[1]; $f++;}}
## To search end 

#####
$e=0;
for($f=0;$f<sizeof($flist);$f++)
{
$e++;
#print "\n $f --> ".$flist[$f];
print "".$flist[$f];
print "\n";
}
fwrite(STDERR, "list of ".$e." Emails : $search_email_id --> $searchdate\n");

#print "\n";
?>
