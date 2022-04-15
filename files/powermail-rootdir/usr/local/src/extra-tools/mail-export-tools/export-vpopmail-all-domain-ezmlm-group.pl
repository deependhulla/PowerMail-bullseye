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
if($tablename ne "valias" && $tablename ne "lastauth" && $tablename ne "dir_control" && $tablename ne "weakpass" && $tablename ne "lastpass")
{
$d++;
$xtablename = $tablename;
$xtablename=~ s/_/"."/eg;
$domainx = $xtablename;

$cmdx='find  /home/vpopmail/domains/'.$domainx.'/ -maxdepth 1 -type l -name .qmail-*  | grep -v "\-owner"  | grep -v "\-return\-default" | grep -v "\-default" ';

$cmdout=`$cmdx`;

$newfilecsv="/root/vpopmail-ezmlm-group-".$tablename.".csv";
print "\n $d CSV FILE CREATED: $newfilecsv ";
open(OUTOACSV,">$newfilecsv");

#print "\n------------------------\n";
#print " $xtablename  --> $cmdx \n";
@linex=();
@linex=split/\n/,$cmdout;

for($e=0;$e<@linex;$e++)
{
$slinex="";
#/home/vpopmail/domains/teamshl.in/.qmail-default
$qfile=$linex[$e];
$qaliasmain=$qfile;
$rml="/home/vpopmail/domains/".$domainx."/.qmail-";
$qaliasmain=~ s/$rml/""/eg;
$qaliasmain=~ s/:/"."/eg;

$qemail=$qaliasmain.'@'.$domainx;
#print "\n [$e] --> $qemail ";

$zl="ezmlm-list /home/vpopmail/domains/".$domainx."/".$qaliasmain."";
$zlout=`$zl`;
@zlinex=();
@zlinex=split/\n/,$zlout;


$slinex=$slinex.$qemail;
$slinex=$slinex."|";
for($z=0;$z<@zlinex;$z++)
{
if($z!=0){
$slinex=$slinex.",";
}
$slinex=$slinex.$zlinex[$z];
}

###################
$mzl="ezmlm-list /home/vpopmail/domains/".$domainx."/".$qaliasmain."/mod";
$mzlout=`$mzl`;
@mzlinex=();
@mzlinex=split/\n/,$mzlout;

$slinex=$slinex."|";
for($mz=0;$mz<@mzlinex;$mz++)
{
if($mz!=0){
$slinex=$slinex.",";
}
$slinex=$slinex.$mzlinex[$mz];
}

###################

$slinex=$slinex."\n";
#print "$slinex";
print OUTOACSV $slinex;



### for loop over for domain list of .qmail
}

close(OUTOACSV);




## if over
}
## while tableloop -first table loop over
}

print "\n";


