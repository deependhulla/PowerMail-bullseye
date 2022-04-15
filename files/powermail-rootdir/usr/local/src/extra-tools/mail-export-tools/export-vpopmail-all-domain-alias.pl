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
$domainx = $xtablename;

$cmdx="find  /home/vpopmail/domains/".$domainx."/ -maxdepth 1 -type f -name .qmail-*";
$cmdout=`$cmdx`;

$newfilecsv="/root/vpopmail-alias-".$tablename.".csv";
print "\n $d CSV FILE CREATED: $newfilecsv ";
open(OUTOACSV,">$newfilecsv");

#print "\n------------------------\n";
#print " $xtablename  --> $cmdx \n";
@linex=();
@linex=split/\n/,$cmdout;

for($e=0;$e<@linex;$e++)
{
#/home/vpopmail/domains/teamshl.in/.qmail-default
$qfile=$linex[$e];
$qaliasmain=$qfile;
$rml="/home/vpopmail/domains/".$domainx."/.qmail-";
$qaliasmain=~ s/$rml/""/eg;
$qaliasmain=~ s/:/"."/eg;
if($qaliasmain ne "default")
{
$slinex="";
$qalias=$qaliasmain;
$qalias=$qalias."\@".$domainx;
#print "\n  ".$linex[$e]."\n";

$slinex=$slinex.$qalias;
$slinex=$slinex."|";

$xcmdx="cat ".$linex[$e];
$xcmdout=`$xcmdx`;
#print "\n -- > $xcmdx  \n $xcmdout";
@xlinex=();
@xlinex=split/\n/,$xcmdout;
$zslinex="";
for($ie=0;$ie<@xlinex;$ie++)
{
if($ie!=0){$slinex=$slinex.",";}
$addx=$xlinex[$ie];
$rmlx="/home/vpopmail/domains/".$domainx."/";

$addx=~ s/$rmlx/""/eg;
$addx=~ s/Maildir/""/eg;
$atdomain="\@".$domainx;
$addx=~ s/\/\//"$atdomain"/eg;

$slinex=$slinex."".$addx;

}


$slinex=$slinex."\n";

#print "$slinex";


print OUTOACSV $slinex;

## if not default over
}

### for loop over
}



close(OUTOACSV);


## if over
}
## while tableloop -first table loop over
}

print "\n";


