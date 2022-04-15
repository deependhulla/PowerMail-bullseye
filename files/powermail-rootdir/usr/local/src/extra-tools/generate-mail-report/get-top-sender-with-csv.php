<?php

$getpass=file_get_contents("/usr/local/src/mysql-admin-pass");
$mysqlcon=mysqli_connect('127.0.0.1', 'admin', $getpass) ;
mysqli_select_db($mysqlcon,"mailscanner");
//$datet=date('Y-m-d');
$datet=date('Y-m-d',strtotime("-1 days"));
$topuser=10;
$csvuser=100;

$hostnamex=`hostname`;
$sqlx="
SELECT
  from_address as name,
  COUNT(*) as count,
  SUM(size) as size
 FROM
  maillog
 WHERE
  from_address <> \"\" 
 AND
  from_address IS NOT NULL 
AND (1=1)
AND
 date = '".$datet."'

 GROUP BY
  from_address
 ORDER BY
  count DESC
 LIMIT ".$topuser."
";

$userx=array();
$u=0;
#print "$sqlx \n";
$htb="<html><body> Below are [".$datet."] details of Top ".$topuser." Sender of server  ".$hostnamex."  with detail attachment of mailers. <br>\n";
$htb=$htb."<table border=1>";

$htb=$htb."<tr>";
$htb=$htb."<td>Sr.</td>";
$htb=$htb."<td>From</td>";
$htb=$htb."<td>Count</td>";
$htb=$htb."<td>Size(MB)</td>";
$htb=$htb."</tr>";
$r=0;
$arsg = mysqli_query($mysqlcon,$sqlx);
while($dx=mysqli_fetch_array($arsg))
{
$r++;
if($dx['count']>=$csvuser){
$userx[$u]=$dx['name'];
$u++;
}
#print_r($dx);
$htb=$htb."<tr>";
$htb=$htb."<td>".$r."</td>";
$htb=$htb."<td>".$dx['name']."</td>";
$htb=$htb."<td>".$dx['count']."</td>";
$htb=$htb."<td>".round(($dx['size']/1048576),2)."</td>";
$htb=$htb."</tr>";
$htb=$htb."";
$htb=$htb."";
$htb=$htb."";
$htb=$htb."";
}

$htb=$htb."</table></body></html>";
$htb=$htb."";
#print "$htb";


$filex="/tmp/report-msg.html";
file_put_contents($filex,$htb);


#################################

for($u=0;$u<sizeof($userx);$u++)
{
print "\n $u --> ".$userx[$u];
$filey="/tmp/".$userx[$u];
$filey=str_replace("@","_",$filey);
$filey=str_replace(".","_",$filey);
$filey=$filey.".csv";
print " --> $filey";


$sqlx="
SELECT
  id AS id2,
  DATE_FORMAT(timestamp, '%d/%m/%y %H:%i:%s') AS datetime,
  from_address,
  to_address,
  size,
clientip,
  subject
 FROM
  maillog
 WHERE
(1=1) AND (1=1)
AND
 date = '".$datet."'
AND
 from_address = '".$userx[$u]."'

  ORDER BY
   date DESC, time DESC
";

#print "\n $sqlx \n";



$r=0;
$csvd="\"Sr\",\"ID\",\"DATE\",\"FROM\",\"TO\",\"SIZE\",\"CLIENTIP\",\"SUBJECT\"\n";
$arsg = mysqli_query($mysqlcon,$sqlx);
while($dx=mysqli_fetch_array($arsg))
{
$r++;
$csvd=$csvd."\"".$r."\"";
$csvd=$csvd.",";
$csvd=$csvd."\"".$dx['id2']."\"";
$csvd=$csvd.",";
$csvd=$csvd."\"".$dx['datetime']."\"";
$csvd=$csvd.",";
$csvd=$csvd."\"".$dx['from_address']."\"";
$csvd=$csvd.",";
$csvd=$csvd."\"".$dx['to_address']."\"";
$csvd=$csvd.",";
$csvd=$csvd."\"".$dx['size']."\"";
$csvd=$csvd.",";
$csvd=$csvd."\"".$dx['clientip']."\"";
$csvd=$csvd.",";
$csvd=$csvd."\"".$dx['subject']."\"";
$csvd=$csvd."\n";
}

file_put_contents($filey,$csvd);

////
}
#################################



$cmdx="/usr/bin/sendEmail -f postmaster@".$hostnamex." -t postmaster@".$hostnamex." -u \" ".$hostnamex." [".$datet."] Details CSV of top-sender as of now  \"  -s 127.0.0.1:25 -o tls=no -o message-file=".$filex."";

for($u=0;$u<sizeof($userx);$u++)
{
$filey="/tmp/".$userx[$u];
$filey=str_replace("@","_",$filey);
$filey=str_replace(".","_",$filey);
$filey=$filey.".csv";
$cmdx=$cmdx." -a ".$filey."";
}


print " \n $cmdx \n";
`$cmdx`;

print "\n";

?>


