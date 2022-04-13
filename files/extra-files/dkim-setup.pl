#!/usr/bin/perl

$newdomain=$ARGV[0];
$newdomain=~ s/\n/""/eg;
$newdomain=~ s/\t/""/eg;
$newdomain=~ s/\r/""/eg;
$newdomain=~ s/ /""/eg;
$newdomain=~ s/;/""/eg;
$newdomain=~ s/,/""/eg;
$newdomain=~ s/'/""/eg;
$newdomain=~ s/\"/""/eg;
#print "--> $newdomain";
#exit;

$cmdx="mkdir /etc/opendkim/keys/".$newdomain."";
`$cmdx`;
$cmdx="cd /etc/opendkim/keys/".$newdomain." ; opendkim-genkey --domain=".$newdomain." --selector=mail";
`$cmdx`;
$cmdx="echo \"mail._domainkey.".$newdomain." ".$newdomain.":mail:/etc/opendkim/keys/".$newdomain."/mail.private\"  >>/etc/opendkim/KeyTable";
`$cmdx`;
$cmdx="echo \"".$newdomain." mail._domainkey.".$newdomain."\" >> /etc/opendkim/SigningTable";
`$cmdx`;
$cmdx="chmod -R 644 /etc/opendkim/keys; chown -R opendkim:opendkim /etc/opendkim/keys;chmod -R 700 /etc/opendkim/keys";
`$cmdx`;

$cmdx="sed -i \"s/:default:/:mail:/\"  /etc/opendkim/KeyTable";
`$cmdx`;

print "\nOpendkim for $newdomain added. \n";
