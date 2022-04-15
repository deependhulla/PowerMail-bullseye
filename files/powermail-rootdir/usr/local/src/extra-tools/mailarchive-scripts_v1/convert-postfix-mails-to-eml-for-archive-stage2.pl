#!/usr/bin/perl


use strict;
use DateTime::Format::Mail;
use Mail::Address;
use Data::Dumper;
use DBI;

my $myfilelist="/tmp/mail-for-process-for-emailarchive-stage2-list";
##my $cmx="find /archive-mail-data/stage1/ -type f > ".$myfilelist;
my $cmx="find /mail-archive-uncompress/ -type f > ".$myfilelist;

#print "\n $cmx ";

`$cmx`;

open (OUTOBXZZ, "<$myfilelist");
my $directeml="";
my $zy=0;

while(<OUTOBXZZ>)
{
$zy++;
$directeml=$_;
$directeml=~ s/\r/""/eg;
$directeml=~ s/\n/""/eg;
print "\n Convert from  $zy -> $directeml";
my $newtmpfile=`perl -MTime::HiRes=time -E 'say time'`;
##my $cmdxpost="/usr/sbin/postcat -hb $directeml  > /archive-mail-data/stage2/".$newtmpfile." ";
my $cmdxpost="/usr/sbin/postcat -hb $directeml  > /mail-archive-process/".$newtmpfile." ";
print "\n $cmdxpost";

my $cmdp1=`$cmdxpost`;

unlink($directeml);

}
close(OUTOBXZZ);

