<?php

## reset groupofficeadmin password
$p=`cat /usr/local/src/groupofficeadmin-pass`;
$p=str_replace("\t","",$p);
$p=str_replace("\r","",$p);
$p=str_replace("\n","",$p);
$p=str_replace("\0","",$p);
$p=str_replace(" ","",$p);

$u='groupofficeadmin';
$di = md5($u. ":Group-Office:" . $p);
$pp = password_hash($p, PASSWORD_DEFAULT);

#print "CLEAR PASS --> $p \n";
#print "DIGEST PASS --> $di \n";
#print "PASSWORD HASH --> $pp \n";

#$sqlx="UPDATE groupoffice.`core_auth_password` SET `password` = '".$pp."', `digest` = '".$di."' WHERE `userId` = 1;";
$sqlx="UPDATE groupoffice.`core_auth_password` SET `password` = '".$pp."' WHERE `userId` = 1;";
#print "$sqlx";
$filesql="/tmp/grouppass.sql";
file_put_contents($filesql,$sqlx);
$cmdx="cat /tmp/grouppass.sql | mysql ";
`$cmdx`;
unlink($filesql);
?>
