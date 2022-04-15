#!/usr/bin/perl
use strict;
use DateTime::Format::Mail;
use Mail::Address;
use Data::Dumper;
use DBI;
use Time::HiRes;
#Time::HiRes::sleep(0.1); #.1 seconds


## mkdir /mail-archive-compress/

my $canwork=1;
if( -e "/tmp/read-mail-and-make-emailarchive.pid")
{
print "\nProcessing Running or remove PID file  /tmp/read-mail-and-make-emailarchive.pid of new to start new process \n ";
$canwork=0;
}

if($canwork==1)
{
print "Working";
my $cmdx2="touch /tmp/read-mail-and-make-emailarchive.pid";
`$cmdx2`;


my $myfilelist="/tmp/mail-for-process-for-emailarchive-final-list";
my $myfilelist2="/mnt/mail-archive-data/server235-list.txt";
my $loc = DBI->connect("dbi:mysql:server=localhost;database=emailarchive;host=localhost",'emailarchive','rocket4040');

## finalfoler without trailing slash /  
##my $finalfolder='/archive-data';

my $finalfolder='/archive-data';



my $cmx="find /mnt/mail-archive-data/server235/ -type f > ".$myfilelist2;

print "\n  $cmx \n";
#`$cmx`;

#exit;



open (OUTOBXXX, "<$myfilelist2");
my $directeml="";
my $zy=0;
my $zyy=0;

while(<OUTOBXXX>)
{
$zy++;
$directeml=$_;
$directeml=~ s/\r/""/eg;
$directeml=~ s/\n/""/eg;
print "\n Reading Email from  $zy -> $directeml";
my $newtmpfile=`perl -MTime::HiRes=time -E 'say time'`;


#print "\n $cmdxpost\n";

#exit;
my $fileisready=0;
open (OUTOB, "<$directeml");
my $mydbx="";
while(<OUTOB>)
{
$fileisready=1;
$mydbx=$mydbx.$_;
}
close(OUTOB);

if($fileisready==1)
{
my $emailmessageid="";
my @emailtolist=();
my $etoi=0;
my $emailfroma="";
my $emailtoa="";
my $emailsuba="";
my $emaildatea="";
my $emailrecvdatea="";
my $finaldate="";
### work on MSG -start
#print  "\n--------------\n";

my $fullemail=$mydbx;
$mydbx=~ s/\r/""/eg;

my @listattach=();
my $lista=0;
######
(my $dheaders, my $dbody) = split (/\n\n/, $mydbx, 2);

my @mailxbody=();@mailxbody=split/\n/,$dbody;
my $miy=0;for($miy=0;$miy<@mailxbody;$miy++){
(my $mnb1,my $mnb2)=split/ontent-Disposition: attachment; filename=/,$mailxbody[$miy];
if($mnb2 ne ""){my $dxzbody=$mailxbody[$miy];$dxzbody=~ s/\"/""/eg;
(my $mnb3,my $mnb4)=split/=/,$dxzbody;$listattach[$lista]=$mnb4;$lista++;}}

my $procheaders = $dheaders;
$procheaders =~ s/\?=\s\n/\?=\n/g; # Lines ending with an encoded-word
                               # have an extra space at the end. Remove it.
$procheaders =~ s/\n[ |\t]//g; # Merge multi-line headers into a single line.
$procheaders =~ s/\'//g; # Merge multi-line headers into a single line.
$procheaders =~ s/\"//g; # Merge multi-line headers into a single line.
##print "\n $procheaders \n";

my $transheaders = '';
my @hlines=();
@hlines=split/\n/,$procheaders;
my $f=0;
for($f=0;$f<@hlines;$f++)
{
my @headnew=split/:/,$hlines[$f];
my $headerkey=$headnew[0];
my $headervalue="";
my $fv=0;
for($fv=1;$fv<@headnew;$fv++)
{
if($fv!=1)
{
$headervalue=$headervalue.":";
}
$headervalue=$headervalue.$headnew[$fv];
}
####### work on Header Starts here
my $headerkeyf=$headerkey;
my $headervaluef=$headervalue;
$headerkey=lc($headerkey);
if($headerkey eq "message-id"){$emailmessageid=$headervalue;}
if($headerkey eq "Sender" && $emailfroma eq ""){$emailfroma=$headervalue;}
if($headerkey eq "from" && $emailfroma eq ""){$emailfroma=$headervalue;}
if($headerkey eq "to"){$emailtoa=$headervalue;}
if($headerkey eq "cc"){$emailtoa=$emailtoa.";".$headervalue;}
if($headerkey eq "bcc"){$emailtoa=$emailtoa.";".$headervalue;}
if($headerkey eq "subject"){$emailsuba=$headervalue;}
if($headerkey eq "date" && $emaildatea eq ""){$emaildatea=$headervalue;

print "--> ".$emaildatea;
(my $ed1,my $ed2)=split/\(/,$emaildatea;
$emaildatea=$ed1;
print "--> ".$emaildatea;
my $mdatetime="";
my $mdatesql="";
eval {
$mdatetime = DateTime::Format::Mail->parse_datetime($emaildatea);
};
if ( $@ ) { print "ERROR: date not valid " }else{
##$mdatetime->set_time_zone('Asia/Kolkata');
$mdatetime->set_time_zone('Asia/Calcutta');
$mdatesql=$mdatetime->ymd('-')." ".$mdatetime->hms(':');
}

$emaildatea=$mdatesql;
}
if($headerkey eq "received" && $emailrecvdatea eq ""){
$headervalue =~ s/\t/ /g;
$headervalue =~ s/  / /g;
$headervalue =~ s/  / /g;
$headervalue =~ s/  / /g;
$headervalue =~ s/  / /g;
$headervalue =~ s/  / /g;
my @recdate=();
@recdate=split/\;/,$headervalue;
my $reci=@recdate;

$emailrecvdatea=$recdate[$reci-1];
print "--> ".$emailrecvdatea;
(my $red1,my $red2)=split/\(/,$emailrecvdatea;
$emailrecvdatea=$red1;
print "--> ".$emailrecvdatea;
my $rdatetime ="";
my $rdatesql="";
eval {
$rdatetime = DateTime::Format::Mail->parse_datetime($emailrecvdatea);
};
if ( $@ ) { print "ERROR: date not valid " }else{
#$rdatetime->set_time_zone('Asia/Kolkata');
$rdatetime->set_time_zone('Asia/Calcutta');
$rdatesql=$rdatetime->ymd('-')." ".$rdatetime->hms(':');
}
$emailrecvdatea=$rdatesql;

}

}

if($emailsuba eq ""){$emailsuba="No Subject";}
$emailfroma=~ s/\r/""/eg;
$emailfroma=~ s/\n/""/eg;
$emailfroma=~ s/\t/""/eg;
$emailfroma=~ s/ /""/eg;
if($emailfroma eq ""){$emailfroma='fromaddress@missing.com';}
if($emailfroma eq "<>"){$emailfroma='fromaddress@missing.com';}
if($emailtoa eq "<>"){$emailtoa='toaddress@missing.com';}
if($emailtoa eq ""){$emailtoa='toaddress@missing.com';}
my @emailfrom1=Mail::Address->parse($emailfroma);
@emailtolist=Mail::Address->parse($emailtoa);
#### refere format from http://search.cpan.org/~drolsky/DateTime-0.70/lib/DateTime.pm

if($emaildatea ne ""){$finaldate=$emaildatea;}
if($emailrecvdatea ne ""){$finaldate=$emailrecvdatea;}
if($finaldate eq "")
{
my $lastupdatedate=time();
my @common_months = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
my @common_monthsc = ('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC');
 (my $common_sec,my $common_min,my $common_hr,my $common_mday,my $common_mon,my $common_year,my $common_wday) = (localtime(time))[0,1,2,3,4,5,6];
  $common_year += 1900;
my $common_month=$common_months[$common_mon];
  my $common_today_date = "$common_months[$common_mon]  / $common_mday / $common_year";
$common_mon=$common_mon+1;
if($common_mon<10){$common_mon="0".$common_mon;}
if($common_mday<10){$common_mday="0".$common_mday;}
if($common_hr<10){$common_hr="0".$common_hr;}
if($common_min<10){$common_min="0".$common_min;}
 $common_today_date = $common_year."".$common_mon."".$common_mday;
my $common_today_mon = $common_year."".$common_mon;
$finaldate=$common_year."-".$common_mon."-".$common_mday." ".$common_hr.":".$common_min.":".$common_sec; 

}


(my $emaildate,my $emailtime)=split/ /,$finaldate;
(my $emailyear,my $emailmon,my $emailday)=split/-/,$emaildate;
(my $emailhour,my $emailmin,my $emailsec)=split/:/,$emailtime;

### Save The Email
use Time::HiRes qw/gettimeofday/;
my ($ddseconds, $ddmicroseconds) = gettimeofday;
#print " $ddseconds --> $ddmicroseconds ";

my $emailmessageidfile=time();
###my $mkfolderforemail="/mnt/sdd3/email-direct-archive/-archive/".$emailyear."/".$emailmon."/".$emaildate."/".$emailhour."/".$emailmin."/".$emailsec."/";
##my $mkfolderforemail="/mnt/mail-archive-data/mail-archive-compress/".$emailyear."/".$emaildate."/".$emailhour."-".$emailmin."/".$emailsec."/";
my $mkfolderforemail=$finalfolder."/".$emailyear."/".$emaildate."/".$emailhour."-".$emailmin."/".$emailsec."/";
my $mkfolderforemail2=$mkfolderforemail.$emailmessageidfile."-".$zyy."-".$ddseconds."-".$ddmicroseconds;
###my $mkfolderforemail2=$mkfolderforemail.$emailmessageidfile."-".$zyy;
my $samemsgid=$emailmessageidfile."-".$zyy."-".$ddseconds."-".$ddmicroseconds;
##my $samemsgid=$emailmessageidfile."-".$zyy;
`mkdir -p $mkfolderforemail`;
print "\n New Email stored   at $mkfolderforemail2\n";
open(OUTOAXYY, ">$mkfolderforemail2");
$fullemail=~ s/\r/""/eg;
print OUTOAXYY $fullemail;
close(OUTOAXYY);
my $emailfilesize = 0;
my $emailfilesizegzip = 0;
$emailfilesize = -s $mkfolderforemail2;
my $mkfolderforemail2gzip=$mkfolderforemail2.".gz";
my $gzipcmd="/bin/gzip -9 $mkfolderforemail2 ";
`$gzipcmd`;
$emailfilesizegzip = -s $mkfolderforemail2gzip;

### Save over

### work for adding to db per TO email
for(my $rv=0;$rv<@emailtolist;$rv++)
{
$zyy++;
print  "\n RVNO - $rv  $zyy ";
print  "\n Mail FromFull in $emailfroma ";
print "\n Mail From in ".$emailfrom1[0]->address;
my $zf=$emailfrom1[0]->address;
(my $z1,my $z2)=split/\@/,$emailfrom1[0]->address;
print  "\n Mail From Domain ".$z2;
#print  "\n Mail Tofull in $emailtoa ";
print  "\n Mail To Single ".$emailtolist[$rv]->address;
(my $z3,my $z4)=split/\@/,$emailtolist[$rv]->address;
my $zt=$emailtolist[$rv]->address;
print  "\n Mail To domain ".$z4;
print  "\n Mail Messageid in $emailmessageid ";
print  "\n Mail Subject in $emailsuba ";
print  "\n Mail Rec-Date in $emailrecvdatea  ";
print  "\n Mail Date in $emaildatea   ";
print  "\n Mail FinalDate in $finaldate  -> $emailyear -> $emailmon -> $emailday -> $emailhour -> $emailmin -> $emailsec   ";

my $emaildatesql=$emaildate;
$emaildatesql=~ s/-/"_"/eg;
my $createsql="CREATE TABLE IF NOT EXISTS `details_".$emaildatesql."` (  `id` bigint(20) NOT NULL auto_increment,  `adddatetime` timestamp NOT NULL default CURRENT_TIMESTAMP,  `adddate` date NOT NULL,  `emaildatetime` timestamp NOT NULL default '0000-00-00 00:00:00',  `emaildate` date NOT NULL,  `emailfrom` varchar(250) NOT NULL,  `emailfromdomain` varchar(250) NOT NULL,  `emailfromfull` varchar(250) NOT NULL,  `emailsender` varchar(250) NOT NULL,  `emailreaderfrom` varchar(250) NOT NULL,  `emailto` varchar(250) NOT NULL,  `emailtodomain` varchar(250) NOT NULL,  `emailtofull` text NOT NULL,  `fetchmailto` varchar(250) NOT NULL,  `messageid` varchar(250) NOT NULL,`samemsgid` varchar(250) NOT NULL,  `subject` varchar(250) NOT NULL,  `plainheader` text NOT NULL,  `attachment01` varchar(250) NOT NULL,  `attachment02` varchar(250) NOT NULL,  `attachment03` varchar(250) NOT NULL,  `attachment04` varchar(250) NOT NULL,  `attachment05` varchar(250) NOT NULL,  `attachment06` varchar(250) NOT NULL,  `attachment07` varchar(250) NOT NULL,  `attachment08` varchar(250) NOT NULL,  `attachment09` varchar(250) NOT NULL,  `attachment10` varchar(250) NOT NULL,  `mailstorepath` text NOT NULL,  `mailsize` int(11) NOT NULL default '0', `mailsizegzip` int(11) NOT NULL default '0',  `sendtime` datetime NOT NULL,  `sendstatus` varchar(250) NOT NULL DEFAULT 'DONE',  `sendfirsttime` datetime NOT NULL,  `sendfirsterror` varchar(250) NOT NULL,  `sendfinalmsg` text NOT NULL,`clientcd` VARCHAR( 250 ) NOT NULL , `subcd` VARCHAR( 250 ) NOT NULL ,`branchcd` VARCHAR( 250 ) NOT NULL, `ecndate` DATE NOT NULL ,`file_prefix` VARCHAR( 250 ) NOT NULL , UNIQUE KEY `id` (`id`), KEY `emailtofull` (`emailtofull`(333)) , KEY `adddate` (`adddate`),  KEY `emailfrom` (`emailfrom`),  KEY `emailfromdomain` (`emailfromdomain`),  KEY `emaildate` (`emaildate`),  KEY `emailto` (`emailto`),  KEY `emailtodomain` (`emailtodomain`),  KEY `subject` (`subject`),  KEY `attachment01` (`attachment01`),  KEY `attachment02` (`attachment02`),  KEY `attachment03` (`attachment03`),  KEY `attachment04` (`attachment04`),  KEY `attachment05` (`attachment05`),  KEY `attachment06` (`attachment06`),  KEY `attachment07` (`attachment07`),  KEY `attachment08` (`attachment08`),  KEY `attachment09` (`attachment09`),  KEY `attachment10` (`attachment10`), KEY `samemsgid` (`samemsgid`),  KEY `messageid` (`messageid`),  KEY `mailsize` (`mailsize`),  KEY `mailsizezip` (`mailsizegzip`),   KEY `sendtime` (`sendtime`), KEY `sendstatus` (`sendstatus`), KEY `sendfirsttime` (`sendfirsttime`), KEY (`clientcd`), KEY (`subcd`), KEY (`branchcd`), KEY (`ecndate`), KEY (`file_prefix`), KEY `sendfirsterror` (`sendfirsterror`), FULLTEXT KEY `sendfinalmsg` (`sendfinalmsg`),FULLTEXT KEY `mailstorepath` (`mailstorepath`), FULLTEXT KEY `plainheader` (`plainheader`)) ENGINE=Aria  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;";

#print "\n-----------------------------------\n";
#print " $createsql ";
#print "\n-----------------------------------\n";
my $loc_db = $loc->prepare($createsql);
$loc_db->execute;

my $sqlx="INSERT INTO `details_".$emaildatesql."` ( `id` ,`adddatetime` ,`adddate` ,`emaildatetime` ,`emaildate` ,`emailfrom` ,`emailfromdomain` ,`emailfromfull` ,`emailsender` ,`emailreaderfrom` ,`emailto` ,`emailtodomain` ,`emailtofull` ,`fetchmailto` ,`messageid` ,`subject` ,`plainheader` ,`attachment01` ,`attachment02` ,`attachment03` ,`attachment04` ,`attachment05` ,`attachment06` ,`attachment07` ,`attachment08` ,`attachment09` ,`attachment10` ,`mailstorepath`,`mailsize`,`mailsizegzip`,`samemsgid`)VALUES (NULL ,CURRENT_TIMESTAMP ,CURDATE(),'".$emaildate." ".$emailtime."','".$emaildate."', '".$zf."', '".$z2."', '".$emailfroma."', '', '', '".$zt."', '".$z4."', '".$emailtoa."', '', '".$emailmessageid."', '".$emailsuba."', '".$procheaders."', '".$listattach[0]."', '".$listattach[1]."', '".$listattach[2]."', '".$listattach[3]."', '".$listattach[4]."', '".$listattach[5]."', '".$listattach[6]."', '".$listattach[7]."', '".$listattach[8]."', '".$listattach[9]."', '".$mkfolderforemail2."','".$emailfilesize."','".$emailfilesizegzip."','".$samemsgid."');";
if($z4 ne "")
{
print "\n-----------------------------------\n";
#print "$sqlx";
#print "\n-----------------------------------\n";
$loc_db = $loc->prepare($sqlx);
$loc_db->execute;
}


#### OTRS START
#print  "\n ------------------------------\n ";
(my $otrs1,my $otrs2)=split/TRS-Notification-Maste/,$emailfroma;
if($otrs1 ne "" && $otrs2 ne "" )
{
#OTRS-Notification-Master
my $otrs3=$emailtoa;
my $otrs4=$emailsuba;
$otrs3=~ s/\@tssl.in/""/eg;
$otrs3=~ s/ /""/eg;
$otrs3=~ s/\t/""/eg;
$otrs3=~ s/\n/""/eg;
$otrs3=~ s/\r/""/eg;

$otrs4=~ s/\"/""/eg;
$otrs4=~ s/\'/""/eg;
$otrs4=~ s/\n/""/eg;
$otrs4=~ s/\r/""/eg;
$otrs4=~ s/\t/""/eg;
my $otrs6="";
my @otrs5=();
@otrs5=split/\n/,$mydbx;
for(my $otrsi=0;$otrsi<@otrs5;$otrsi++)
{
(my $otrs7,my $otrs8)=split/3DAgentZoom/,$otrs5[$otrsi];
if($otrs7 ne "" && $otrs8 ne "")
{

$otrs6=$otrs5[$otrsi];
$otrs6=~ s/=3D/"="/eg;
$otrs6=~ s/\"//eg;

}
}

#print "\n $otrs5  \n";
#print "\nSPARKALERT  $emailfroma -->".$emailtoa."--> $emailsuba";
#my $otrscmd="/usr/bin/php /usr/local/src/make-archive-index/winpopup.php \"".$otrs3."\" \"".$otrs4."\" \"".$otrs6."\"  ";
#print "\n SPARK  $otrscmd";
#`$otrscmd`;

}
#### OTRS end

### loop for to add is over
}



unlink($directeml);

### fileready if over here
}


}
close(OUTOBXXX);
print "\n";

print "\n ..Done.\n";
my $cmdx4="/bin/rm -rf /tmp/read-mail-and-make-emailarchive.pid";
`$cmdx4`;

}

## work over

