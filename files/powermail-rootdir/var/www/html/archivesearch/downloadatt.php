<?php
#print "Content-type: text/html\n\n";
$e=0;
$qsdata=$_SERVER["QUERY_STRING"];
$qsdata=str_replace("..","",$qsdata);
$qsdata=str_replace("|","",$qsdata);
$qsdata=str_replace(";","",$qsdata);
$qsdata=str_replace(":","",$qsdata);
$indata=array();
$indata=explode("&",$qsdata);
$filex="";
$folder="";
for($e=0;$e<sizeof($indata);$e++)
{
$datax=array();
$datax=explode("=",$indata[$e]);
if($datax[0]=="folder"){$folder=$datax[1];}
if($datax[0]=="filex"){$filex=$datax[1];}
}

#print "aa -> $qsdata --> $folder -->$filex";
$gfile=$folder.urldecode($filex);
$filey=urldecode($filex);
#print "Content-type: text/html\n\n";
#print "-->".$filey."<---";
#exit;
if(file_exists($gfile))
{
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="'.$filey.'"');
#     header('Content-Disposition: attachment; filename="downloaded.pdf"');
    readfile($gfile);
    exit;
}
else
{
print "Content-type: text/html\n\n";
print "Cannot Download Attachment : $filey (Try opening email again)";
}
?>
