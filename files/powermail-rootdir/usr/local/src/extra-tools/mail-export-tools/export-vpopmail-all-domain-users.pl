#!/usr/bin/perl
use DBI;
#############

open(OUTOAZ,"</home/vpopmail/etc/vpopmail.mysql");
while(<OUTOAZ>)
{
$aj=$_;
$aj=~ s/\n/""/eg;
$aj=~ s/\r/""/eg;
($mysqlhost,$mysqlport,$mysqlusername,$mysqlpass,$mysqldb)=split/\|/,$aj;
#print "--> $mysqlhost,$mysqlport,$mysqlusername,$mysqlpass,$mysqldb";
}
close(OUTOAZ);
my $dbh = DBI->connect("dbi:mysql:server=".$mysqlhost.";database=".$mysqldb.";host=".$mysqlhost."",$mysqlusername,$mysqlpass);
die "\n Unable for connect to MySQL server $DBI::errstr \n" unless $dbh;


$sqlin="SHOW TABLES;";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$d=0;
while(($tablename)=$table_data->fetchrow_array)
{
if($tablename ne "valias" && $tablename ne "lastauth" && $tablename ne "dir_control")
{
$d++;
$xtablename = $tablename;
$xtablename=~ s/_/"."/eg;

$sqlx="SELECT pw_name,pw_passwd,pw_uid,pw_gid,pw_gecos,pw_dir,pw_shell,pw_clear_passwd FROM ".$mysqldb.".`".$tablename."`  order by pw_name";
#print "\n --> $sqlx";
$xtable_data = $dbh->prepare($sqlx);
$xtable_data->execute;
$newfilecsv="/root/vpopmail-domain-".$tablename.".csv";
print "\n $d CSV FILE CREATED: $newfilecsv ";
open(OUTOACSV,">$newfilecsv");
while(($pw_name,$pw_passwd,$pw_uid,$pw_gid,$pw_gecos,$pw_dir,$pw_shell,$pw_clear_passwd,$ltime,$remote_ip)=$xtable_data->fetchrow_array)
{
$pwx=$pw_shell;
$pwx=~ s/,4000C/""/eg;
$pwx=~ s/S/""/eg;
$linex=$pw_name."\@".$xtablename.",".$pwx.",".$pw_clear_passwd;
$linex=$linex."\n";
print OUTOACSV $linex; 

}
close(OUTOACSV);

## if loop not as valias first table loop over
}
## while tableloop -first table loop over
}

print "\n";


