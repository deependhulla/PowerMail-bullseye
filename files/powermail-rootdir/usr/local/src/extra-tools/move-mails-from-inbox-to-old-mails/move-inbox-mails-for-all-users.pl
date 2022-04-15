#!/usr/bin/perl
# check for domain
# check for account is mailbox or alias
# then give info


###$newin=$ARGV[0];
$newin='powermaildomain.com';
$newin=~ s/\n/""/eg;
$newin=~ s/\t/""/eg;
$newin=~ s/\r/""/eg;
$newin=~ s/ /""/eg;
$newin=~ s/;/""/eg;
$newin=~ s/\*/""/eg;
$newin=~ s/%/""/eg;
$newin=~ s/,/""/eg;
$newin=~ s/'/""/eg;
$newin=~ s/\"/""/eg;
#print "\n--> $newin\n";


use DBI;

open(OUTOAZ,"</home/powermail/etc/powermail.mysql");
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
die "\n Unable for connect to powermail MySQL server $DBI::errstr \n" unless $dbh;
$gonow=1;

if($newin eq "")
{
$gonow=0;
print "please provide domainname . example : vdomaindetails deependhulla.com  ";
}
$domaingot=$newin;

$sqlin="SELECT `domain` FROM `domain` WHERE `domain` = '".$domaingot."' ";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$domanok=0;
while(($gdomainname)=$table_data->fetchrow_array)
{
$domainok=1;
}

if($domainok==0 && $gonow==1){$gonow=0; print "\nDomain ".$domaingot." not on this server.\n";}

if($gonow==1)
{
$sqlx="SELECT `username`, `password`, `name`, `maildir`, `quota`, `domain`, `created`, `modified`, `active` FROM `mailbox` WHERE `domain` = '".$newin."' ";

#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
print '"Mailbox","Password","Details","Path","QuotaBytes","Created","Modify","Active","Type"';
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
##print "\n\"".$guser."\",\"".$gpass."\",\"".$gname."\",\"/home/powermail/domains/".$gmaildir."Maildir/\",\"".$gquota."\",\"".$gdom."\",\"".$gcreate."\",\"".$gmod."\",\"".$gact."\",\"MAILBOX\"";
$guseronly=$guser;
$newinu='@'.$newin;
$guseronly=~ s/$newinu/""/eg;
#print $guser;
$cmdx="perl move-inbox-mail-per-user.pl ".$guser;
print "$cmdx";
print "\n";
##### while end
}




}


print "\n";
