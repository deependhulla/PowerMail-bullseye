#!/usr/bin/perl


$newin=$ARGV[0];
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

@datax=split/\@/,$newin;

$newfolder="OldMails";
$noofdays_before_from_today=29;


$mainf="/home/powermail/domains/".$datax[1]."/".$datax[0]."/Maildir/";


$newx=$mainf.".".$newfolder."/new";
$curx=$mainf.".".$newfolder."/cur";
$tmpx=$mainf.".".$newfolder."/tmp";

$mkdirx="mkdir -p \"".$newx."\"; ";print "$mkdirx \n";
$mkdirx="mkdir -p \"".$curx."\"; ";print "$mkdirx \n";
$mkdirx="mkdir -p \"".$tmpx."\"; ";print "$mkdirx \n";

$cmdx="chown -R vmail:vmail ".$mainf.".".$newfolder."/";

print "$cmdx \n ";
$subx ="echo \"".$newfolder."\" > ".$mainf."subscriptions";
print "$subx \n ";


$movx="find ".$mainf."cur/ -type f -mtime +".$noofdays_before_from_today." -exec mv -v \"{}\" ".$curx."/ \\;";
print "$movx \n";
#.OldMails

print "\n";
