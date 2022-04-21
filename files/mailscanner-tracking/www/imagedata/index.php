<?php

if(ini_get('zlib.output_compression')) { ini_set('zlib.output_compression', 'Off'); }
header('Pragma: public');   // required
header('Expires: 0');       // no cache
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Cache-Control: private',false);
header ('Content-Type: image/png');
header('Content-Transfer-Encoding: binary');
header('Content-Length: '.filesize('blank.png'));   // provide file size
readfile('blank.png');      // push it out
exit();

?>

