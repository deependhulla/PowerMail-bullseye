<?php
require_once 'IP2Location.php';
/*
   Cache whole database into system memory and share among other scripts & websites
   WARNING: Please make sure your system have sufficient RAM to enable this feature
*/
// $db = new \IP2Location\Database('./databases/IP-COUNTRY-SAMPLE.BIN', \IP2Location\Database::SHARED_MEMORY);

/*
   Cache the database into memory to accelerate lookup speed
   WARNING: Please make sure your system have sufficient RAM to enable this feature
*/
// $db = new \IP2Location\Database('./databases/IP-COUNTRY-SAMPLE.BIN', \IP2Location\Database::MEMORY_CACHE);


/*
	Default file I/O lookup
*/
$db = new \IP2Location\Database('IP2LOCATION-LITE-DB1.BIN', \IP2Location\Database::FILE_IO);
$iphere=$argv[1];
$records = $db->lookup($iphere, \IP2Location\Database::ALL);
$fx=$argv[2];
if($fx =="")
{
#echo '<pre>';
#echo 'IP Number             : ' . $records['ipNumber'] . "\n";
#echo 'IP Version            : ' . $records['ipVersion'] . "\n";
echo 'IP Address            : ' . $records['ipAddress'] . "\n";
echo 'Country Code          : ' . $records['countryCode'] . "\n";
echo 'Country Name          : ' . $records['countryName'] . "\n";
#echo '</pre>';
}
else
{
print $records['ipAddress'].",".$records['countryCode'].",".$records['countryName']."";
}
?>
