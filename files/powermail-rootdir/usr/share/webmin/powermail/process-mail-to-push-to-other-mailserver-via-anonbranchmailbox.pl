#!/usr/bin/perl

$nonbranchmailbox='exchange_catchall@goldsgym.in';

use DBI;
use File::Copy;


($nonuserx,$nondomainx)=split/\@/,$nonbranchmailbox;
$nonbranchfolderx="/home/powermail/domains/".$nondomainx."/".$nonuserx."/Maildir/new/";

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


$sqlin="SELECT `username` FROM `powermailbox`  WHERE `deliveryto` = 'other'";
#print " -- $sqlin";

$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$ginfo,$goto,$gown,$gdom,$gcreate,$mtime,$gact,$gsend)=$table_data->fetchrow_array)
{
#print "\n $guser";
($userx,$domainx)=split/\@/,$guser;
$folderx="/home/powermail/domains/".$domainx."/".$userx."/Maildir/new/";
$foldercur="/home/powermail/domains/".$domainx."/".$userx."/Maildir/cur/";
#print " --> $userx --> $domainx -->$folderx";

#opendir ( DIR, $folderx ) || print  "No Group Mail started $foldexx\n";
opendir ( DIR, $folderx ) ;
while( ($filex = readdir(DIR))) {
if($filex ne "." && $filex ne "..")
{ 
 $mailx=$folderx.$filex; 
print " $mailx  --> $nonbranchfolderx \n";
move($mailx,$nonbranchfolderx);

## if file over
}
## while loop of dir over
}
closedir(DIR);


## db while loop over
}
print "\n";
