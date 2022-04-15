<?php
$loginok=0;
$debugnow=0;
$filexx="/var/log/nginx/userauth.log";

$gloginuser=$_SERVER['HTTP_AUTH_USER'];
$gloginpass=$_SERVER['HTTP_AUTH_PASS'];
$glogintype=$_SERVER['HTTP_AUTH_METHOD'];
$gloginpro=$_SERVER['HTTP_AUTH_PROTOCOL'];
$goforsql=0;
$filex=file_get_contents('user-allowed.php');
$filey=explode("\n",$filex);

for($e=0;$e<sizeof($filey);$e++)
{
$uchk=$filey[$e];
$uchk=str_replace("\n","",$uchk);
$uchk=str_replace("\r","",$uchk);
$uchk=str_replace("\t","",$uchk);
$uchk=str_replace("\0","",$uchk);
$uchk=str_replace(" ","",$uchk);
$uchk=str_replace("","",$uchk);
$uchk=str_replace("","",$uchk);
$uchk=str_replace("","",$uchk);
if($uchk!="")
{
/////
file_put_contents($uchk, "UCHK:$gloginpass\n", FILE_APPEND);
//print "\n $e -->".$uchk."<--";
if($uchk==$gloginuser){$goforsql=1;}
//////
}}

if($goforsql==1){


$ebdbname="powermail"; $ebdbuser="powermail"; $ebdbhost="localhost"; $ebdbpass="Ut6ootie";
$mysqldblink = new mysqli($ebdbhost, $ebdbuser, $ebdbpass, $ebdbname);
// if($mysqldblink->connect_errno > 0){     die('Unable to connect to database [' . $mysqldblink->connect_error . ']'); }
##$gloginuseru=str_replace("@manugraph.com","",$gloginuser);
$gloginuseru=str_replace("","",$gloginuser);

$sqlx="SELECT `username` , `password`  FROM `mailbox` WHERE `username` = '".$gloginuseru."' AND `password` = '".$gloginpass."'";
$mysqlresult = $mysqldblink->query($sqlx);
while($m1 = $mysqlresult->fetch_assoc()){
$loginok=1;
}
//go for sql --over
}


# foreach($_SERVER as $key => $value){ file_put_contents('/tmp/test.txt', "SERVER:$key:$value\n", FILE_APPEND);}


if($debugnow==1)
{
file_put_contents($filexx, "USER:$gloginuser on ".date(DATE_RFC2822)." \n", FILE_APPEND);
file_put_contents($filexx, "PASS:$gloginpass\n", FILE_APPEND);
file_put_contents($filexx, "SQL:$sqlx\n", FILE_APPEND);
file_put_contents($filexx, "METH:$glogintype\n", FILE_APPEND);
file_put_contents($filexx, "PROT:$gloginpro\n", FILE_APPEND);
file_put_contents($filexx, "ALLOWED:$goforsql\n", FILE_APPEND);
file_put_contents($filexx, "OK:$loginok\n\n", FILE_APPEND);
}

if($loginok==0)
{
header('Auth-Status: Invalid Login or Password or Not Allowed');
//header('Auth-Wait:1');
}
if($loginok==1){
header('Auth-User: '.$gloginuser);
header('Auth-Pass: '.$gloginpass);
header('Auth-Status: OK');
header('Auth-Method: plain');
header('Auth-Server: 127.0.0.1');
if($gloginpro=="smtp"){header('Auth-Port: 25');}
if($gloginpro=="imap"){header('Auth-Port: 143');}
if($gloginpro=="pop3"){header('Auth-Port: 110');}
}
?>

