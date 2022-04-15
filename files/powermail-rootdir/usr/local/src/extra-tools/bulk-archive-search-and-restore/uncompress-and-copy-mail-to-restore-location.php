<?php


$readlist="/tmp/tmp-restore-list.txt";

## restore in folder (latter rsync or scp to users folder )
$restore_in_folder="/home/archive-data-restored";


$em=explode("@",$argv[1]);
$ed=$em[1];
$eb=$em[0];
$d=$restore_in_folder."/".$ed."/".$eb."/Maildir/.Archive-".$argv[2]."";

## make runcmd to 0 for dry run  only rpint else 1 will run the cmd
$runcmd=1;
echo " Working on copy, uncompress into folder $d";
###################################
###################################
$fd=file_get_contents($readlist);
$fdx=array();
$fdx=explode("\n",$fd);
$e=0;
$f=sizeof($fdx) ;
for($i=0;$i<sizeof($fdx);$i++){if($fdx[$i] !=""){$e++;$f=$e;}}

$e=0;
for($i=0;$i<sizeof($fdx);$i++)
{
if($fdx[$i] !=""){
$e++;
if(!file_exists($d))
{
$cmdx="mkdir -p ".$d."/cur"; `$cmdx`;
$cmdx="mkdir -p ".$d."/new"; `$cmdx`;
$cmdx="mkdir -p ".$d."/tmp"; `$cmdx`;
$cmdx="chown -R vmail:vmail ".$d.""; `$cmdx`;
print " \n Creating.. $cmdx";
}

#print "\n Restoring $e of $f --> ".$fdx[$i];
$cmdx=" /bin/cp -pRv \"".$fdx[$i]."\" ".$d."/cur/";
#print "\n $cmdx";
if($runcmd==1){ $cmdout=`$cmdx`;}
}
}

print "copying done..uncompressing now...";
$cmdx="gzip -f -d ".$d."/cur/*.gz ;chown -R vmail:vmail ".$d." ";
#print "\n$cmdx\n";
if($runcmd==1){ $cmdout=`$cmdx`;}

print " done\n";
?>
