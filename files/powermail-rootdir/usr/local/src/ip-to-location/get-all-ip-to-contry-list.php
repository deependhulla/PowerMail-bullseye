<?php

require_once 'IP2Location.php';
$db = new \IP2Location\Database('IP2LOCATION-LITE-DB1.BIN', \IP2Location\Database::FILE_IO);


$filex=$argv[1];

$filedata=file_get_contents($filex);

#print $filedata;
$linex=array();
$linex=explode("\n",$filedata);
$f=0;

for($i=0;$i<sizeof($linex);$i++)
{
if($linex[$i] !="")
{
$f++;
print "$f -> ";
#print "$f -> ".$linex[$i];
$iphere=$linex[$i];
$records = $db->lookup($iphere, \IP2Location\Database::ALL);
print $records['ipAddress'].",".$records['countryCode'].",".$records['countryName']."";
print "\n";
}
}


?>
