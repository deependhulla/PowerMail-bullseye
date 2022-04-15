<?php

//error_reporting(0);
//ini_set('display_errors', 1);
//error_reporting(E_ALL);
## should be without trailing /   (no slash)
##$vmainpath="/archive-mail-data";
$vmainpath="/mail-archive-compress";
$vmainpath="/archive-mail-data";

$smtphost="127.0.0.1";
$smtpport="25";


$enkey="getkeynowxyz";

###boxtype =0 means datewise (2016_03_20)
###boxtype =1 means monthwise (2016_03)
###boxtype =2 means yearwise (2016)

$boxtype=2;



function encode($string,$key) {  
$j=0;
$key = sha1($key);
$strLen = strlen($string);
$keyLen = strlen($key);
for ($i = 0; $i < $strLen; $i++) {
$ordStr = ord(substr($string,$i,1));
if ($j == $keyLen) { $j = 0; }
$ordKey = ord(substr($key,$j,1));
$j++;
$hash .= strrev(base_convert(dechex($ordStr + $ordKey),16,36));
}
return $hash;
}
function decode($string,$key) {
$key = sha1($key);
$strLen = strlen($string);
$keyLen = strlen($key);
for ($i = 0; $i < $strLen; $i+=2) {
$ordStr = hexdec(base_convert(strrev(substr($string,$i,2)),36,16));
if ($j == $keyLen) { $j = 0; }
$ordKey = ord(substr($key,$j,1));
$j++;
$hash .= chr($ordStr - $ordKey);
}
return $hash;
}

#$encoded = encode($globalwebmailuser , $enkey);
#echo $encoded;
#echo "\n";
#$decoded = decode($encoded, $enkey);
#echo $decoded;
#echo "\n";

$globalwebmailuser="";
$cookie_name = "mailarchiveid";
$loginok=0;
if(isset($_COOKIE[$cookie_name])) {
$decoded = decode($_COOKIE[$cookie_name], $enkey);
if($decoded)
{
$globalwebmailuser=$decoded;
$loginok=1;
}
}


if($loginok==0)
{
$_COOKIE[$cookie_name]="";
session_destroy();
header("location:/groupoffice/index.php");
exit;

}

if($loginok==1)
{

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> -->
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<title>ArchiveMail Search.</title>

<style type="text/css">
                @import url("css/style.css");
                @import url('css/style_text.css');
                @import url('css/c-grey.css'); /* COLOR FILE CAN CHANGE TO c-blue.ccs, c-grey.ccs, c-orange.ccs, c-purple.ccs or c-red.ccs */
                @import url('css/datepicker.css');
                @import url('css/form.css');
                @import url('css/menu.css');
                @import url('css/messages.css');
                @import url('css/statics.css');
                @import url('css/tabs.css');
                @import url('css/wysiwyg.css');
                @import url('css/wysiwyg.modal.css');
                @import url('css/wysiwyg-editor.css');
        </style>

        <script type="text/javascript" src="js/jquery-1.6.1.min.js"></script>

        <!--[if lte IE 8]>
                <script type="text/javascript" src="js/excanvas.min.js"></script>
        <![endif]-->
<script language="javascript" type="text/javascript">
/*
Auto center window script- Eric King (http://redrival.com/eak/index.shtml)
Permission granted to Dynamic Drive to feature script in archive
For full source, usage terms, and 100's more DHTML scripts, visit http://dynamicdrive.com
*/

var win = null;
function NewWindowMail(mypage,myname,w,h,scroll){
LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
settings =
'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',resizable'
win = window.open(mypage,myname,settings)
win.focus();
}
</script>


</head>
<body>
<div class="wrapper">
        <div class="container">

                <!--[if !IE]> START TOP <![endif]-->
                <div class="top">
                        <div class="split"><h1>ArchiveMail Search</h1></div>
                        <div class="split">
                <div class="logout"><img src="images/icon-logout.gif" align="left" alt="" /> <a href="#" onclick="window.close();return false;">Close</a></div>
                                <div><img src="images/icon-welcome.gif" align="left" alt="Welcome" /> Welcome <?php echo $globalwebmailuser; ?></div>
                        </div>
                </div>
                <!--[if !IE]> END TOP <![endif]-->

                <!--[if !IE]> START MENU <![endif]-->
                <div class="menu">
                        <ul>
                                <li><a href="?fun=advanceemailsearch">Advance Email Search</a></li>
                                <li class="break"></li>
                        </ul>
                </div>

<div class="holder">
<!-- HTML BODY for Work START here -->
<?php
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
$fun=$_GET['fun'];
if($fun ==""){$fun=$_POST['fun'];}
if($fun ==""){$fun=$_GET['fun'];}

#print " --> $loginok --> $globalwebmailuser ";
$searchmaintype=$_POST['searchmaintype'];
$searchdate=$_POST['searchdate'];
$searchcomtype=$_POST['searchcomtype'];
$searchcom=$_POST['searchcom'];
$searchsub=$_POST['searchsub'];
$searchsubtype=$_POST['searchsubtype'];
$searchacc=$_POST['searchacc'];

if($searchmaintype == ""){$searchmaintype=$_GET['searchmaintype'];}
if($searchdate == ""){$searchdate=$_GET['searchdate'];}
if($searchcomtype == ""){$searchcomtype=$_GET['searchcomtype'];}
if($searchcom == ""){$searchcom=$_GET['searchcom'];}
if($searchsub == ""){$searchsub=$_GET['searchsub'];}
if($searchsubtype == ""){$searchsubtype=$_GET['searchsubtype'];}
if($searchacc == ""){$searchacc=$_GET['searchacc'];}


if($searchmaintype =="fromto"){$searchmaintypefromto="selected";}
if($searchmaintype =="to"){$searchmaintypeto="selected";}
if($searchmaintype =="from"){$searchmaintypefrom="selected";}
if($searchdate ==""){$searchdate=date("Y")."-".date("m");}
$noofrec=$_POST['noofrec'];
if($noofrec==""){$noofrec=$_GET['noofrec'];}
if($noofrec=="100"){$nofrec100="selected";}
if($noofrec=="200"){$nofrec200="selected";}

if($fun=="restoreemail")
{
print "Restoring Mails..Please Wait...<br>";
$resz=0;
for($cv=0;$cv<300;$cv++)
{
$chkkey="chkid_".$cv;
$chkvalue=$_POST[$chkkey];
if($chkvalue!="")
{
$resz++;
#print "<hr> $cv --> ".$chkvalue;
$mfile = decode($chkvalue, $enkey);
#print "--> MFILEX : --> $mfile";

$xfile=$mfile;
$zfile=array();
$zfile=explode("/",$mfile);
$xfile="/tmp/".$zfile[sizeof($zfile)-1];
#$xfile="/tmp/".$zfile[sizeof($zfile)-1];
$mfile=str_replace("/headerdata/","/maindata/",$mfile);
$cmdx="/bin/cp -pRv ".$mfile." ".$xfile." ; /bin/gzip  -d ".$xfile."";
$xfile=str_replace(".gz","",$xfile);
$cmdxout=`$cmdx`;
#print "<hr> $cmdx  --> $xfile : $cmdxout<hr>";
if (file_exists($xfile)) {
 #   echo "The file $filename exists";

$sendnowx="sendEmail -f ".$globalwebmailuser." -t ".$globalwebmailuser." -s ".$smtphost.":".$smtpport." -o message-format=raw -o message-file=".$xfile."  -o tls=no ";
$cc=`$sendnowx`;
#print "<br> Mail send <br> $sendnowx";
print "<br>Restoring Mail $resz :<font color=green>  ".$cc."</font>";

}


}
}

}


/////////////////

if($fun!="searchresult"  && $fun!="viewemail" && $fun!="restoreemail")
{
#print "FUN: - $fun";
$eeacemail=$globalwebmailuser;
?>
<div class="box">
<div class="title">
<h2>Search</h2>
<img src="images/title-hide.gif" class="toggle" alt="" />
</div>
<div class="content messages">
<form name="searchnow" action="index.php" method=get>
<input type="hidden" name="fun" value="searchresult">
Search for Email Communication <font color=red>*</font> <select name="searchmaintype">
<option value="from" <?=$searchmaintypefrom?>>From </option>
<option value="to" <?=$searchmaintypeto?>>To </option>
</select>
Email 
<?php

$zemailz=array();
$zemailz=explode("@",$eeacemail);
if($zemailz[0]=="postmaster")
{
print "<input type=\"text\" name=\"searchacc\" id=\"searchacc\" value=\"".$eeacemail."\" size=40>";
}
else
{
?>

<?php
$readfilex=file_get_contents('data-map.php');
#print "--> $readfilex";
$extradata1=str_replace("\r","",$extradata1);
$extradata1=explode("\n",$readfilex);
$extraemail=array();
$zei=0;
for($ze=0;$ze<sizeof($extradata1);$ze++)
{
$zer=array();
$zer=explode(":",$extradata1[$ze]);
if($zer[0] == $eeacemail){
#print "<br> $ze --> ".$zer[1];
$extraemail[$zei]=$zer[1];
$zei++;
}
}
?>
Email
<select name="searchacc" id="searchacc">
<?php
#if($zei!=0){ print "<option value=\"all\">All</option>";}
print "<option value=\"".$eeacemail."\">".$eeacemail."</option>";
for($ze=0;$ze<sizeof($extraemail);$ze++)
{
print "<option value=\"".$extraemail[$ze]."\">".$extraemail[$ze]."</option>";
}
?>
</select>


<!-- 
<select name="searchacc">
<option value="<?php echo $eeacemail; ?>"><?php echo $eeacemail; ?></option>
</select> -->
<?php
}
?>
<br>Search in (Year/Month/Date) Enter (YYYY for Year or YYYY-MM for Month or YYYY-MM-DD for Day)
 <font color=red>*</font> <input type=text name="searchdate"  value="<?=$searchdate?>">
<br>
Communicated with 
Email/Domain  <font color=red>*</font> <input type="text" name="searchcom" value="<?=$searchcom?>" size=40>
<br>Containing Subject : <input type="text" name="searchsub" value="<?=$searchsub?>" size=40>
<br>Show No of Records : <select name="noofrec">
<option value="100" <?=$nofrec100?>>100 Records per Page</option>
<option value="200" <?=$nofrec200?>>200 Records per Page</option>
</select>
<br><input type="submit" name="usubmit" value="Search" style="color:white; font-size:11px; font-weight : bold; background-color:green" onclick="document.searchnow.usubmit.value='Please wait..';document.searchnow.submit();">
<br></form>
<br></div></div>

<?php

}
//////////////////////


if($fun=="searchresult")
{

$edate=explode("-",$searchdate);
$yearx=$edate[0];
$monx=$edate[1];
$datex=$edate[2];
$foldercheck="";
if($boxtype==2){$foldercheck=$yearx;}
if($boxtype==1){$foldercheck=$yearx."_".$monx;}
if($boxtype==0){$foldercheck=$yearx."_".$monx."_".$datex;}
#print " --> $yearx  --> $monx --> $datex <--";

$qx1="";$qx2="";$qx3="";$qx4="";$qx5="";$qx="";
if($searchmaintype == "from" and $searchcom!=""){$qx1 = "author:".$searchacc." AND rcpt:".$searchcom."  "; $qx=$qx.$qx1;  }
if($searchmaintype == "to" and $searchcom!=""){$qx1 = "rcpt:".$searchacc." AND author:".$searchcom."  "; $qx=$qx.$qx1;  }


if($searchmaintype == "from" and $searchcom==""){$qx1 = "author:".$searchacc."   "; $qx=$qx.$qx1;  }
if($searchmaintype == "to" and $searchcom==""){$qx1 = "rcpt:".$searchacc."   "; $qx=$qx.$qx1;  }
$qx= $qx." AND date :".$searchdate." ";
if($searchsub != ""){$qx3 = "AND subject:".$searchsub."  ";  $qx=$qx.$qx3;}

$cmdx="/usr/bin/recoll -t -m -n ".$noofrec."  -c  ".$vmainpath."/".$foldercheck."/indexdata/ -q \"(".$qx.")\" ";

#print " --> $cmdx";

$cmdoutx=`$cmdx`;
$cmdout=explode("\n",$cmdoutx);
###print "<pre> $cmdout </pre>";

$resultbox=$cmdout[1];
$xmailfrom=array();
$xmailto=array();
$xmailsubj=array();
$xmailtime=array();
$xmailgzip=array();
$xmailabst=array();
$xmailfile=array();
$m=0;
$ex=0;
#print "<br>$resultbox <hr>";
for($e=2;$e<sizeof($cmdout);$e++)
{
$s1="";$s2="";
$s3=array();
$s3=explode(" = ",$cmdout[$e]);
$s1=$s3[0];
$s2=$s3[1];
#print "<pre><br>\n$e [$m] -->".$cmdout[$e]." --> ".$s1;
if($s1 == "abstract"){$xmailabst[$m]=$s2;}
if($s1 == "author"){$xmailfrom[$m]=$s2;}
if($s1 == "recipient"){$xmailto[$m]=$s2;}
if($s1 == "caption"){$xmailsubj[$m]=$s2;}
if($s1 == "dmtime"){$xmailtime[$m]=$s2;}
if($s1 == "pcbytes"){$xmailgzip[$m]=$s2;}
if($s1 == "url"){$xmailfile[$m]=$s2;}

$ex++;
if($s1 == "url"){$ex=0;$m++;}
### for cmdout over
}




///////
?>
<!-- TABLE DESIGN START -->
<form name="mybox" action="index.php" method=post>
<div class="box"><div class="title"><h2>Email Search : <?php echo $resultbox; ?> </h2>
<!-- <img src="images/title-hide.gif" class="toggle" alt="" /> -->
</div>
<div class="content pages">


<input type="hidden" name="fun" value="restoreemail">
<table><thead><tr>
 <td><input type="checkbox" class="checkall" /></td>  
<td>Sr.</td><td>Email From</td><td>Email To</td>
<td>Subject</td><td>Dated</td></tr></thead><tbody>
<?php

$jsid=1;
for($m=0;$m<sizeof($xmailfrom);$m++)
{
## list to display started
$xmailfrom[$m]=str_replace("<","&lt;",$xmailfrom[$m]);
$xmailto[$m]=str_replace("<","&lt;",$xmailto[$m]);
$xmailabst[$m]=str_replace("<","&lt;",$xmailabst[$m]);
#print "\n<hr>";
$xmailfile[$m]=str_replace("\n","",$xmailfile[$m]);
$xmailfile[$m]=str_replace("\t","",$xmailfile[$m]);
$xmailfile[$m]=str_replace("\r","",$xmailfile[$m]);
$xmailfile[$m]=str_replace("\0","",$xmailfile[$m]);
$xmailfile[$m]=str_replace("file://","",$xmailfile[$m]);
#print "<a href =\"#\"  onClick=\"NewWindow('view_archive_mail.php?mfile=".$xmailfile[$m]."&forwardto=".$forwardto."','sdsdsd1','800','500','yes');return false;\">";
#print "".$xmailabst[$m]." ";
#print "</a>";
print "\n<tr class=\"grey\">";

##print "<td><input type=\"checkbox\" name=\"chkid_".$jsid."\" value=\"".$tey[5]."__".$tey[0]."\" /></td>";
$xencoded = encode($xmailfile[$m] , $enkey);
print "<td><input type=\"checkbox\" name=\"chkid_".$jsid."\" value=\"".$xencoded."\" /></td>";

$maildate=$xmailtime[$m];
$maildate=date('d M Y H:i:s', $xmailtime[$m] );
##$xencoded = encode($xmailfile[$m] , $enkey);

$forwardto=$globalwebmailuser;
print "<td> ".$jsid."</td><td >".$xmailfrom[$m]."&nbsp;</td><td >".$xmailto[$m]."&nbsp;</td><td ><a href =\"#\"  onClick=\"NewWindowMail('view_archive_mail.php?mfilex=".$xencoded."&forwardto=".$forwardto."','mailsd1','800','500','yes');return false;\"   style=\"color:red\">".$xmailsubj[$m]."</a></td><td nowrap>".$maildate."</td>";

##print "<td>".$jsid."</td><td >".$xmailfrom[$m]."&nbsp;</td><td >".$xmailto[$m]."&nbsp;</td><td ><a href =\"#\"  onClick=\"NewWindowMail('view_archive_mail.php?mfile=".$xmailfile[$m]."&forwardto=".$forwardto."','mailsd1','800','500','yes');return false;\"   style=\"color:red\">".$xmailsubj[$m]."</a></td><td nowrap>".$maildate."</td>";
print "</tr>";


$jsid++;

/// for loop of list over
}


?>

</tbody></table></form><div class="pages-bottom">
<div class="actionbox">
<button type="usubmit" onClick="if(confirm('Are you sure you want to restore selected emails?')){document.mybox.submit();}return false;" ><span>Restore selected to my Inbox</span></button></div>

<div class="pagination">
<!-- 1,2,3,4 -->
</div>
</div>



<?php
}
////////////


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
?>
<!-- HTML BODY for Work END here -->
</div>



                <div class="footer">
                        <div class="split">&#169; Copyright <a href="http://technoinfotech.com">TechnoInfotech,India</a></div>
               <!--         <div class="split right">Maintained by <a href="mailto:support@technoinfotech.com">TechnoInfotech Support Team</a></div> -->
                </div>



</div></div>

<script type="text/javascript" src="js/jquery-ui.js"></script>
<script type="text/javascript" src="js/jquery.pngFix.js"></script>
<script type="text/javascript" src="js/hoverIntent.js"></script>
<script type="text/javascript" src="js/superfish.js"></script>
<script type="text/javascript" src="js/supersubs.js"></script>
<script type="text/javascript" src="js/date.js"></script>
<script type="text/javascript" src="js/jquery.sparkbox-select.js"></script>
<script type="text/javascript" src="js/jquery.datepicker.js"></script>

<script type="text/javascript" src="js/jquery.filestyle.mini.js"></script>
<script type="text/javascript" src="js/jquery.flot.js"></script>
<script type="text/javascript" src="js/jquery.graphtable-0.2.js"></script>
<script type="text/javascript" src="js/jquery.wysiwyg.js"></script>
<script type="text/javascript" src="js/plugins/wysiwyg.rmFormat.js"></script>
<script type="text/javascript" src="js/controls/wysiwyg.link.js"></script>
<script type="text/javascript" src="js/controls/wysiwyg.table.js"></script>
<script type="text/javascript" src="js/controls/wysiwyg.image.js"></script>

<script type="text/javascript" src="js/inline.js"></script>
</body>
</html>


<?php


/// if f login ok  -- over
}
?>
