<html><head><title>Change Email Password </title>
</head>
<body bgcolor="#f1f1f1">
<center><font face="Verdana" size="3"><b>Change Email Password</b></font>
<br><br>
<?php 

$errorx=0;
$errormsg="";
$userid=$_POST['userid'];
$rashpswd=$_POST['rashpswd'];
$newpswd=$_POST['newpswd'];
$renewpswd=$_POST['renewpswd'];
$raship=$_SERVER['REMOTE_ADDR'];
#$checkdic=`./checkdicpass.pl "$newpswd"`;
#print "\n  password : $newpswd \n";  
#print "\n  $checkdic \n";

$userid=str_replace("\n","",$userid);
$userid=str_replace("\r","",$userid);
$userid=str_replace("|","",$userid);
$userid=str_replace("\"","",$userid);
$userid=str_replace("'","",$userid);
$userid=str_replace(";","",$userid);
$userid=str_replace(",","",$userid);
$userid=str_replace(" ","",$userid);
$rashpswd=str_replace(" ","",$rashpswd);

if($userid !="" && $rashpswd !="")
{
##$getpass="/home/vpopmail/bin/webmailvuserinfo -C ".$userid;
$getpass="/home/powermail/bin/vuserinfo ".$userid." | grep \"Clear Pass\" | cut -d \" \" -f 5";
$passgot=`$getpass`;


$passgot=str_replace("\n","",$passgot);
$passgot=str_replace("\r","",$passgot);

#print "-- > $getpass -->$passgot<--";
}
else
{
$errorx=1;
}
#print " $userid --> $passgot --> $rashpswd  --> $newpswd --> $renewpswd";
if($passgot!=$rashpswd && $rashpswd!="" && $errorx==0){$errorx=1;}
if($errorx==0 && $newpswd != $renewpswd ){$errorx=2;}







if($errorx==1){$errormsg= "Old Password Incorrect";}
if($errorx==2){$errormsg= "New Password & Re-type New Password are Incorrect";}

if($errorx==0)
{
#$newpswd=str_replace("@","\@",$newpswd);
$newpswd=str_replace("$","\$",$newpswd);
$newpswd=str_replace(" ","",$newpswd);
#####$setpass="/home/vpopmail/bin/webmailvpasswd ".$userid." \"".$newpswd."\" ";
$newpswd=str_replace("\$","\\\$",$newpswd);
#$newpswd=str_replace("%","\%",$newpswd);
$setpass="/home/powermail/bin/vpasswd ".$userid." \"".$newpswd."\" ";
`$setpass`;
#print " <hr> $setpass <hr>";

$gb="";
$gbi=0;

$cmd1="/bin/touch /tmp/read-changepass-dovecot-restart.pid";
//print $cmd1;
//shell_exec (`$cmd1`);


print "<center> <font color=green>Your password  for email <b> ".$userid."</b> has changed successully.<br><br> Click here to access <a href=\"/\">TechnoMail Services</a></font></center>";
}


if($errorx!=0)
{

print "<center><font color=red> $errormsg , <a href=\"index.php\">Please go back and try again</a> </font>";
}



