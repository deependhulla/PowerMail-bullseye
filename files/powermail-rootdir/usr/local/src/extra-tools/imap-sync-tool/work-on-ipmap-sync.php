<?php

$filein="list-of-users-for-imap-sync.txt";
$fdata=file_get_contents($filein);
$fdata=str_replace("\t","",$fdata);
$fdata=str_replace("\r","",$fdata);
$fdata=str_replace("\0","",$fdata);
$fdata=str_replace(" ","",$fdata);
$fdatax=array();
$fdatax=explode("\n",$fdata);


for($e=0;$e<sizeof($fdatax);$e++)
{
if($fdatax[$e] !="")
{
print " echo \"------------------------------------------\"\n";
print "echo \"".$e." - ".$fdatax[$e]."\" \n";

$dx=array();
$dx=explode(",",$fdatax[$e]);

$cmdx="imapsync --host1 oldserver.com --port1 143 --user1 ".$dx[0]." --password1 '".$dx[1]."'  --host2 localhost --port2 143 --user2 ".$dx[2]." --password2 '".$dx[3]."' --syncinternaldates --exclude Calendar";

## for Fetchmail option
#$cmdx="user ".$dx[0]." with pass '".$dx[1]."' is ".$dx[0]." here forcecr keep smtphost 127.0.0.1/2525";

print "$cmdx  \n";

}
}

print "\n\n";
?>
