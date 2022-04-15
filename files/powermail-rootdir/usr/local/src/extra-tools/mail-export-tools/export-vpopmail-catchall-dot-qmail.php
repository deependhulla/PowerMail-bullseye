<?php
$domainx=$argv[1];
$cmdx="find  /home/vpopmail/domains/".$domainx."/ -maxdepth 1 -type f -name .qmail-*";
$cmdout=`$cmdx`;
$linex=array();
$linex=explode("\n",$cmdout);
$u=0;
for($e=0;$e<sizeof($linex);$e++)
{
if($linex[$e] !="")
{
#print "\n $e --> ".$linex[$e];
$filedata=file_get_contents($linex[$e]);
#print "$filedata";
$ex=array();
$ex=explode("catchall",$filedata);
$esize=sizeof($ex);
if($esize>1)
{
$u++;
#print " -->".$esize;
#print "$filedata";
$dotqmail=$linex[$e];
$dotqmail=str_replace("/home/vpopmail/domains/".$domainx."/","",$dotqmail);
$dotqmail=str_replace(".qmail-","",$dotqmail);
$dotqmail=str_replace(":",".",$dotqmail);
print $dotqmail;
print "\n";
}

}
}

print "\n";
?>

