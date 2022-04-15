#!/usr/bin/perl
use DBI;
use File::Copy;

open(OUTOAZ,"</home/powermail/etc/powermail.mysql");
while(<OUTOAZ>)
{
$aj=$_;
$aj=~ s/\n/""/eg;
$aj=~ s/\r/""/eg;
($mysqlhost,$mysqlport,$mysqlusername,$mysqlpass,$mysqldb)=split/\|/,$aj;
##print "--> $mysqlhost,$mysqlport,$mysqlusername,$mysqlpass,$mysqldb";
}
close(OUTOAZ);

my $dbh = DBI->connect("dbi:mysql:server=".$mysqlhost.";database=".$mysqldb.";host=".$mysqlhost."",$mysqlusername,$mysqlpass); die "\n Unable for connect to MySQL server $DBI::errstr \n" unless $dbh;


$sqlin="SELECT `address`,`info`, `member`, `owner`, `domain`, `created`, `modified`, `active`, `sendtype` FROM `powermaillist` WHERE `active` =1 ";

#print " -- $sqlin";

$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$ginfo,$goto,$gown,$gdom,$gcreate,$mtime,$gact,$gsend)=$table_data->fetchrow_array)
{
$sendtomember=0;
print "\nGROUP $guser \n";
($userx,$domainx)=split/\@/,$guser;
$folderx="/home/powermail/domains/".$domainx."/".$userx."/Maildir/new/";
$foldercur="/home/powermail/domains/".$domainx."/".$userx."/Maildir/cur/";
$postcur="/home/powermail/domains/".$domainx."/postmaster/Maildir/cur/";
#print " --> $userx --> $domainx -->$folderx";

#opendir ( DIR, $folderx ) || print  "No Group Mail started $foldexx\n";
opendir ( DIR, $folderx ) ;
while( ($filex = readdir(DIR))) {
if($filex ne "." && $filex ne "..")
{ 
 $mailx=$folderx.$filex; 
print "\n READING $mailx \n";
$mdata="";
$mfrom="";
$m=0;

open(OUTOATT,"<$mailx");
while(<OUTOATT>)
{
if($m<3)
{
($keyx,$valuex)=split/:/,$_;
#print "-->".$keyx."<-->".$valuex."<--\n";
if($keyx eq "Return-Path"){$mfrom=$valuex;}
if($keyx eq "Return-Group-Path"){$mfrom=$valuex;}
$mfrom=~ s/\</""/eg;
$mfrom=~ s/\>/""/eg;
$mfrom=~ s/\n/""/eg;
$mfrom=~ s/\r/""/eg;
$mfrom=~ s/\t/""/eg;
$mfrom=~ s/ /""/eg;
}
#$maj=$_;
#$maj=~ s/Delivered-To:/"Delivered-Group-To:"/eg;
#$maj=~ s/Return-Path:/"Return-Group-Path:"/eg;
#$mdata=$mdata.$maj;
$m++;
}
close(OUTOATT);
#print "From : $mfrom \n";
#print "$mdata";
#$maily=$mailx;
#$maily=~ s/\</""/eg;
#$maily=~ s/\>/""/eg;
#$maily=~ s/,/""/eg;
#$maily=~ s/=/""/eg;
#$maily=~ s/new/"tmp"/eg;
#print "\nTEMP Saving $maily \n";
#open(KOUTOATT,">$maily");
#print KOUTOATT $mdata;
#close(KOUTOATT);


@eto=(); 
@eto=split/,/,$goto;

@eown=(); 
@eown=split/,/,$gown;

if($gsend eq "ANYONE") {$sendtomember=1;}
if($gsend eq "MEMBERS" || $gsend eq "MEMBERS_AND_OWNERS") {
for($e=0;$e<@eto;$e++)
{
$tox=$eto[$e];$tox=~ s/\t/""/eg;$tox=~ s/\n/""/eg;$tox=~ s/\r/""/eg;$tox=~ s/ /""/eg;
if($tox ne "")
{
#print "\n MEMBER: ".$tox; 
if($mfrom eq $tox){$sendtomember=1;}
}
}
}

if($gsend eq "OWNERS" || $gsend eq "MEMBERS_AND_OWNERS") {
for($e=0;$e<@eown;$e++)
{
$tox=$eown[$e];$tox=~ s/\t/""/eg;$tox=~ s/\n/""/eg;$tox=~ s/\r/""/eg;$tox=~ s/ /""/eg;
if($tox ne "")
{
#print "\n OWNER: ".$tox; 
if($mfrom eq $tox){$sendtomember=1;}
}
}
}


if($mfrom ne "" && $sendtomember==1)
{


for($e=0;$e<@eto;$e++)
{
$tox=$eto[$e];
$tox=~ s/\t/""/eg;
$tox=~ s/\n/""/eg;
$tox=~ s/\r/""/eg;
$tox=~ s/ /""/eg;

if($tox ne "")
{
($tuserx,$tdomainx)=split/\@/,$tox;
$tfolderx="/home/powermail/domains/".$tdomainx."/".$tuserx."/Maildir/new/";
#$cmdx="/usr/bin/sendEmail -s 127.0.0.1:25 -f ".$mfrom." -t ".$tox."  -o message-format=raw -o message-file=\"".$maily."\"";

$cmdx="/bin/cp -pRv \"".$mailx."\" ".$tfolderx."";

print "\n $cmdx";
$cmdxout=`$cmdx`;
}
### for eto list --from goto --over
}

## sendto memberok over
}

#####move($maily,$foldercur);
move($mailx,$postcur);
#unlink($mailx);
## if file over
}
## while loop of dir over
}
closedir(DIR);


## db while loop over
}
print "\n";
