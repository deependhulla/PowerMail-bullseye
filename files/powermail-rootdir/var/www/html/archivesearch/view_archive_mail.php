<?php

$smtphost="127.0.0.1";
$smtpport="25";

$enkey="getkeynowxyz";


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
$mfilex=$_GET['mfilex'];
$mfile = decode($mfilex, $enkey);

#print "--> MFILEX : $mfilex --> $mfile";

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
$mailfrom=$globalwebmailuser;






#print "Content-type: text/html\n\n";
$e=0;
$qsdata=$_SERVER["QUERY_STRING"];
$qsdata=str_replace("..","",$qsdata);
$qsdata=str_replace("|","",$qsdata);
$qsdata=str_replace(";","",$qsdata);
$qsdata=str_replace(":","",$qsdata);
$indata=array();
$indata=explode("&",$qsdata);
$mfile="";
$forwardto="";
$sendmailnow="";
for($e=0;$e<sizeof($indata);$e++)
{
$datax=array();
$datax=explode("=",$indata[$e]);
if($datax[0]=="mfile"){$mfile=urldecode($datax[1]);}
if($datax[0]=="forwardto"){$forwardto=urldecode($datax[1]);}
if($datax[0]=="sendmailnow"){$sendmailnow=urldecode($datax[1]);}
}

#print "aa -> $qsdata --> $mfile -->$forwardto --> $sendmailnow";
#exit;
$mfile = decode($mfilex, $enkey);
#print "--> MFILEX : $mfilex --> $mfile";

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

require_once 'vendor/autoload.php';
$Parser = new PhpMimeMailParser\Parser();
#print "--> $xfile ";
if (file_exists($xfile)) {
 #   echo "The file $filename exists";
}
else
{
#print "NO File";
}
$Parser->setPath($xfile);

#echo $Parser->getRawHeader('diagnostic-code');

$to = $Parser->getHeader('to');
$from = $Parser->getHeader('from');
$subject = $Parser->getHeader('subject');
$maildatex = $Parser->getHeader('date');
$stringHeaders = $Parser->getHeadersRaw();  // Get all headers as a string, no charset conversion
$arrayHeaders = $Parser->getHeaders();      // Get all headers as an array, with charset conversion
$text = $Parser->getMessageBody('text');
$html = $Parser->getMessageBody('html');
$htmlem = $Parser->getMessageBody('htmlEmbedded'); //HTML Body included data

#print "\n --> $from -->$to --> $subject --> $maildatex";
$from=str_replace("<","&lt;",$from);
$to=str_replace("<","&lt;",$to);
print "From : ".$from."<br>";
print "To : ".$to."<br>";
print "Subject : ".$subject."<br>";
print "Date : ".$maildatex."";
$attach_dir = $xfile."_attach_tmp/";     // Be sure to include the trailing slash
mkdir($attach_dir, 0777, true);
$include_inline = false ;
$Parser->saveAttachments($attach_dir,[$include_inline]);
$attachments = $Parser->getAttachments([$include_inline]);
?>
<script>
function okf()
{
document.myform.submit();
}
</script>

<?php

if($sendmailnow =="")
{
print '<font color=brown><form name="myform" action="view_archive_mail.php" method="GET">Restore/Forward to <input type=text name=forwardto value="'.$forwardto.'" size=30><input type=hidden name=mfilex value="'.$mfilex.'"> <input type=hidden name=sendmailnow value=yes> <input type=button name="sendnow"  value="Send Now" onclick="okf();return false;"></form></font>';
}
else
{

$sendnowx="sendEmail -f ".$mailfrom." -t ".$forwardto." -s ".$smtphost.":".$smtpport." -o message-format=raw -o message-file=".$xfile."  -o tls=no ";
$cc=`$sendnowx`;
#print "<br> Mail send <br> $sendnowx";
print "<br><font color=green> Mail send ".$cc."</font>";
}

//  Loop through all the Attachments
if (count($attachments) > 0) {
print "<hr>";
    foreach ($attachments as $attachment) {
        echo '<a href="downloadatt.php?folder='.$attach_dir.'&filex='.$attachment->getFilename().'">'.$attachment->getFilename().' ('.filesize($attach_dir.$attachment->getFilename()).' Bytes)</a><br />';
    }
}
print "<hr>";
$donex=0;
#if($html !=""){print "".$html."<hr>"; $donex=1;}
if($htmlem !=""){print "".$htmlem."<hr>"; $donex=1;}
if($html !="" && $donex==0){print "".$html."<hr>"; $donex=1;}
if($donex==0){print "<pre>".$text."</pre><hr>";}


}

?>
