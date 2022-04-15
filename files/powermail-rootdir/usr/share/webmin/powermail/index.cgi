#!/usr/bin/perl
use DBI;
use WebminCore;
  init_config();

#### show goto address in list of alias  by making it 1 , good for small setup not for big setup
$show_goto_address=0;


###ui_print_header(undef, 'PowerMail Management', '');
open(OUTOAZ,"</home/powermail/etc/powermail.mysql");
while(<OUTOAZ>)
{
$aj=$_;
$aj=~ s/\n/""/eg;
$aj=~ s/\r/""/eg;
($mysqlhost,$mysqlport,$mysqlusername,$mysqlpass,$mysqldb)=split/\|/,$aj;
##print "--> $mysqlhost,$mysqlport,$mysqlusername,$mysqlpass,$mysqldb";
}
close(OUTOAZ);
my $dbh = DBI->connect("dbi:mysql:server=".$mysqlhost.";database=".$mysqldb.";host=".$mysqlhost."",$mysqlusername,$mysqlpass);
die "\n Unable for connect to MySQL server $DBI::errstr \n" unless $dbh;

&ReadParse();

@domainshere=();
$e=0;

$sqlin="SELECT `domain` FROM `domain` WHERE `backupmx` = 0 AND `active` = 1 ORDER BY `domain` ASC";
#print " -- $sqlin";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;

while(($domainnamex)=$table_data->fetchrow_array)
{
$domainshere[$e]=$domainnamex;
$e++;
}



#### Export Users List --start
if($in{'fun'} eq "exportuser" )
{
print "Content-type: text/csv\n";
print "Content-Disposition: attachment; filename=exportuser-".$in{'vpopmaildomain'}.".csv\n\n";
#print "Content-type: text/plain\n\n";

$vdomain=$in{'vpopmaildomain'};
$vdomainok=0;
for($r=0;$r<@domainshere;$r++)
{
if($domainshere[$r] eq $vdomain)
{
$vdomainok=1;
}
}

if($vdomainok==0 && $vdomain ne "")
{
print "<font color=red> Domain : <strong> $vdomain </strong> is not valid or you do not have access.</font>";
exit;
}
$newin=$vdomain;


$sqlx="SELECT `username`, `password`, `name`, `maildir`, `quota`, `domain`, `created`, `modified`, `active` FROM `mailbox` WHERE `domain` = '".$newin."' ";

$sqlx="SELECT a.`username`, a.`password`, a.`name`, a.`maildir`, a.`quota`, a.`domain`, a.`created`, a.`modified`, a.`active`,b.`autoclean_trash`, b.`autoclean_spam`, b.`autoclean_promo`, b.`change_pass_max_days`, b.`change_pass_alerts_before_days`, FROM_UNIXTIME(b.`lastlogintime`), b.`lastloginip`,b.`deliveryto`  FROM `mailbox`  as a LEFT JOIN `powermailbox` as b ON a.`username` = b.`username`  where  a.`domain` = '".$newin."'  order by a.username ";

#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
#print '"Mailbox","Password","Details","Path","QuotaBytes","Created","Modify","Active","Type"';
print '"Mailbox","Details","Path","QuotaBytes","Created","Modify","Active","Type","Delivery"';
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact,$atrash,$aspam,$apromo,$passmax,$passalert,$lasttime,$lastip,$deli)=$table_data->fetchrow_array)
{
##print "\n\"".$guser."\",\"".$gpass."\",\"".$gname."\",\"/home/powermail/domains/".$gmaildir."Maildir/\",\"".$gquota."\",\"".$gcreate."\",\"".$gmod."\",\"".$gact."\",\"MAILBOX\"";
print "\n\"".$guser."\",\"".$gname."\",\"/home/powermail/domains/".$gmaildir."Maildir/\",\"".$gquota."\",\"".$gcreate."\",\"".$gmod."\",\"".$gact."\",\"MAILBOX\",\"".$deli."\"";
}


print "\n\n";
print '"Alias","GoTo","Domain","Created","Modify","Active","Type"';


$sqlx="SELECT `address`, `goto`, `domain`, `created`, `modified`, `active`  FROM `alias` WHERE `domain` = '".$newin."' and `address` NOT IN (SELECT `username` FROM `mailbox` WHERE `domain` = '".$newin."' )";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
while(($gaddress,$ggoto,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
$ggoto=~ s/,/", "/eg;

print "\n\"".$gaddress."\",\"".$ggoto."\",\"".$gdom."\",\"".$gcreate."\",\"".$gmod."\",\"".$gact."\",\"ALIAS\"";
}

print "\n\n";
print '"List","GoTo","Owner","Domain","Created","Modify","Send_Type","Active","Type"';

$sqlin="SELECT `address`,`info`, `member`, `owner`, `domain`, `created`, `modified`, `active`, `sendtype` FROM `powermaillist` as a  WHERE `domain` = '".$newin."' ";
#print " -- $sqlin";

$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$ginfo,$goto,$gown,$gdom,$gcreate,$mtime,$gact,$gsend)=$table_data->fetchrow_array)
{
$goto=~ s/,/", "/eg;
$gown=~ s/,/", "/eg;

print "\n\"".$guser."\",\"".$goto."\",\"".$gown."\",\"".$gdom."\",\"".$gcreate."\",\"".$gmtime."\",\"".$gsend."\",\"".$gact."\",\"LIST\"";

}



&webmin_log("Email", "Export Users", "".$in{'vpopmaildomain'}." ");
exit;

}
#### export over


ui_print_header(undef, 'PowerMail Management', '');

print <<"XYZYY";

<script>
function deluser()
{
if(confirm("Are you Sure you want to delete this user ?"))
{
document.indexf.fun.value="deleteuser";
document.indexf.submit();
}
return false;
}

function delalias()
{
if(confirm("Are you Sure you want to delete this Alias ?"))
{
document.indexf.fun.value="deletealias";
document.indexf.submit();
}
return false;
}


function dellist()
{
if(confirm("Are you Sure you want to delete this Group Mailing List ?"))
{
document.indexf.fun.value="deletelist";
document.indexf.submit();
}
return false;
}

function Val_pass(dom_name)
{

var errorMsg = "";
var space  = " ";
fieldname   = document.indexf.vuserpass;
fieldname_re = document.indexf.vuserpasscheck.value;
fieldvalue  = fieldname.value;
fieldvalue_new = fieldvalue.toLowerCase();
fieldlength = fieldvalue.length;
newuser = document.indexf.vusername.value;
newuser_new = newuser.toLowerCase();
domain = dom_name;
domain_new = domain.toLowerCase();
//It must not contain a space
if (fieldvalue.indexOf(space) > -1) {
     errorMsg += "\\nPasswords cannot include a space.\\n";
}
//It must contain at least one number character
if (!(fieldvalue.match(/[0-9]/))) {
     errorMsg += "\\nStrong passwords must include one or more numbers.\\n";
}
//It must start with at least one letter
if (!(fieldvalue.match(/^[a-zA-Z]+/))) {
//     errorMsg += "\\nStrong passwords must start with at least one letter.\\n";
}
//It must contain at least one upper case character
if (!(fieldvalue.match(/[A-Z]/))) {
 errorMsg += "\\nStrong passwords must include one uppercase letter.\\n";
}
//It must contain at least one lower case character
var dvdx=0;
if (!(fieldvalue.match(/[a-z]/)) ) {
 errorMsg += "\\nStrong passwords must include one or more letters.\\n";
dvdx++;
}
if (!(fieldvalue.match(/[A-Z]/)) ) {
//     errorMsg += "\\nStrong passwords must include one or more letters.\\n";
//dvdx++;
}
if(dvdx==0)
{
// errorMsg += "\\nStrong passwords must include one or more letters.\\n";
}
//It must contain at least one special character
if (!(fieldvalue.match(/\[^A-Za-z0-9_]/))) {
     errorMsg += "\\nStrong passwords must include special character - #,@,%,!\\n";
}
//It must be at least 8 characters long.
if (!(fieldlength >= 8)) {
     errorMsg += "\\nStrong passwords must be at least 8 characters long.\\n";
}
// Password and Confirm Password must be same
if(fieldvalue != fieldname_re){
errorMsg += "\\nPassword and Confirm Password not matched.\\n";
}
//Password Should Not Have Any Word from Domain Name.
newd = domain_new.split(".");
len = newd.length;
var search_term = '';
var b=0;
for(i=0;i<=len-1;i++)
{
if(fieldvalue_new.match(newd[i]))
{
b++;
}
}
if(b!==0)
{
errorMsg += "\\nPassword Should not Contain Any Word Form Domain Name.\\n";
}

//Password Should not Contain Any Word Form User Name
newu = newuser_new.split(/[^a-zA-Z]/);
len = newu.length;
var search_term = '';
for (var i=len-1; i>=0; i--) {
    if (newu[i] === search_term) {
       newu.splice(i, 1);
    }
}
var a=0;
var new_len = newu.length;
for(i=0;i<=new_len-1;i++)
{
if(fieldvalue_new.match(newu[i]))
{
a++;
}
}

if(a!==0)
{
errorMsg += "\\nPassword Should not Contain Any Word Form User Name\\n";
}
//////////////////////////////////////////////////////

if(fieldvalue =="" &&  fieldname_re ==""){
errorMsg='';
}

//If there is a problem with the form then display an error
     if (errorMsg != ""){
          msg = "______________________________________________________\\n\\n";
          errorMsg += alert(msg + errorMsg+"\\n");
          fieldname.focus();
          return false;
     }
     return true;
}

</script>

XYZYY



print "<form name=\"indexf\" action=\"$ENV{'SCRIPT_NAME'}\" method=post>";
##################################
if($in{'vpopmaildomain'}  eq "")
{
print "<center>Select the domain to begin the mail user & group management.<br><br> Domain: <select name=\"vpopmaildomain\">";
for($r=0;$r<@domainshere;$r++)
{
print "<option>$domainshere[$r]</option>";
}
print "</select><br><Br><input type=\"submit\" name=\"show1\" value=\"Begin -> Next\"></center>";
}

$vdomain=$in{'vpopmaildomain'};
$vdomainok=0;
for($r=0;$r<@domainshere;$r++)
{
if($domainshere[$r] eq $vdomain)
{
$vdomainok=1;
}
}

if($vdomainok==0 && $vdomain ne "")
{
print "<font color=red> Domain : <strong> $vdomain </strong> is not valid or you do not have access.</font>";
exit;
}
######### valid domain start
if($vdomain ne "")
{
print "<input type=\"hidden\" name=\"vpopmaildomain\" value=\"".$in{'vpopmaildomain'}."\">";
#$in{'vpopmaildomain'}="sample.com";


print "<center>";
print ui_table_start('Management for '.$in{'vpopmaildomain'}, 'width=100% align=center', 8);
print ui_table_row('<a href=\'index.cgi?fun=adduser&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Add Email User</a>');
print ui_table_row('<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Manage Email Users</a>');
print ui_table_row('<a href=\'index.cgi?fun=searchuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Search Users</a>');
print ui_table_row('<a href=\'index.cgi?fun=exportuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Export Users</a>');
print ui_table_row('<a href=\'index.cgi?fun=addalias&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Add Email Alias</a>');
print ui_table_row('<a href=\'index.cgi?fun=listalias&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Manage Email Alias</a>');
print ui_table_row('<a href=\'index.cgi?fun=addlist&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Add Group Mailing List</a>');
print ui_table_row('<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&\'>Manage Group Mailing List</a>');

print ui_table_end();
#### Save User -- start
if($in{'fun'} eq "saveadduser")
{
$okforsave=1;
$newuser=$in{'vusername'};
$newpass=$in{'vuserpass'};
$newpasscheck=$in{'vuserpasscheck'};
$newpass=~ s/\"/"\\\""/eg;
$newpasscheck=~ s/\"/"\\\""/eg;

if($newuser eq ""){$okforsave=0; $exmsg="<br>Please provide Username.";}
if($newpass eq ""){$okforsave=0; $exmsg="<br>Password not enter properly.";}
if($newpasscheck eq ""){$okforsave=0; $exmsg="<br>Password not enter properly.";}
if($newpass ne $newpasscheck  ){$okforsave=0;$exmsg="<br>Password not enter properly.";}

$sqlx="SELECT `username`, `password`, `name`, `maildir`, `quota`, `domain`, `created`, `modified`, `active` FROM `mailbox` WHERE `domain`='".$vdomain."' and `username` = '".$newuser."@".$vdomain."' ";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
$okforsave=0;$exmsg="<br> Mailbox ".$newuser."@".$vdomain."  already exists.";
}
$sqlx="SELECT `address`  FROM `alias` WHERE `address` = '".$newuser."@".$vdomain."'  and `address`  NOT IN ( SELECT `username` FROM `mailbox` WHERE `domain` = '".$vdomain."'  ) and `domain` = '".$vdomain."'  ";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
while(($gaddress)=$table_data->fetchrow_array)
{
$okforsave=0;$exmsg="<br> Alias ".$newuser."@".$vdomain."  already exists.";
}

if($okforsave==0)
{
print "<font color=red> ".$exmsg."</font><br> ";
$in{'fun'}='adduser';
}

$vuserdisk=$in{'vuserdiskquota'} * $in{'vuserdiskquota_units'} ;
#print " --> ".$in{'vuserdiskquota'} ." -->".$in{'vuserdiskquota_units'}." --> ".$vuserdisk;

if($okforsave==1)
{

$newin=$newuser."@".$vdomain;
$userx=$newuser;
$domaingot=$vdomain;

$sqlx="INSERT INTO `mailbox` (`username`, `password`, `name`, `maildir`, `quota`, `local_part`, `domain`, `created`, `modified`, `active`) VALUES ('".$newin."', '".$newpass."', '".$in{'vuserfullname'}."', '".$domaingot."/".$userx."/', '".$vuserdisk."', '".$userx."', '".$domaingot."', NOW(), NOW(), '1');";

#print "<br>\n$sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$sqlx="INSERT INTO `alias` (`address`, `goto`, `domain`, `created`, `modified`, `active`) VALUES ('".$newin."', '".$newin."','".$domaingot."', NOW(), NOW(), '1');";
#print "<br>\n$sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;


$exmsg="User ".$newuser."@".$vdomain." added successfuly. ";
print "<font color=green> ".$exmsg."</font><br> ";
}
### Webin log of addnew user
&webmin_log("Powermail", "adduser", "".$newuser." Success:".$okforsave." ".$exmsg." ");

}
### save User --end

####### Add user Page --start
if($in{'fun'} eq "adduser")
{
print "<br>";
print ui_table_start('Add a new Email User @'.$vdomain, undef, 2);
print ui_table_row('Enter new Username',ui_textbox('vusername', $in{'vusername'}, 40).'@'.$vdomain.'');
print ui_table_row('Enter new password',ui_password('vuserpass', undef, 40));
print ui_table_row('Enter new password again',ui_password('vuserpasscheck', undef, 40));
print ui_table_row('Fullname / Info',ui_textbox('vuserfullname', $in{'vuserfullname'}, 40).'');
print ui_table_row('Disk Quota [0 means Unlimited]',ui_bytesbox('vuserdiskquota', $in{'vuserdiskquota'}, 40).' (1073741824 bytes = 1GB)');
print ui_hidden('fun', 'saveadduser', 40);
#print ui_table_row('&nbsp;',ui_submit('Add new email user', 'fun2'));
print ui_table_row("<input type='submit' name='show1' value='Add New Email User' onClick='return Val_pass(\"".$vdomain."\");'>");
print ui_table_end();

}
####### Add user Page --end

### Save New Alias -start  ####
if($in{'fun'} eq "savenewalias")
{
$okforsave=1;
$newuser=$in{'vmailof'};

if($in{'vmailto'} eq "" || $in{'vmailof'} eq "")
{

$okforsave=0;$exmsg="<font color=red><br>Information are not filed properly.</font>";
print "$exmsg";
$in{'fun'}='addalias';
}

if($in{'vmailto'} ne "" && $in{'vmailof'} ne "")
{
$vmailof=$in{'vmailof'};
$vmailto=$in{'vmailto'};
$vmailof=~ s/\n/""/eg;
$vmailof=~ s/\r/""/eg;
$vmailof=~ s/\t/""/eg;
$vmailof=~ s/\\/""/eg;
$vmailof=~ s/'/""/eg;
$vmailof=~ s/"/""/eg;
$vmailof=~ s/\#/""/eg;
$vmailof=~ s/ /""/eg;
$vmailof1=$vmailof;
$valias=$vmailof."@".$in{'vpopmaildomain'};

$vmailto=~ s/\n/""/eg;
$vmailto=~ s/\r/""/eg;
$vmailto=~ s/\t/""/eg;
$vmailto=~ s/\\/""/eg;
$vmailto=~ s/'/""/eg;
$vmailto=~ s/"/""/eg;
$vmailto=~ s/\#/""/eg;
$vmailto=~ s/ /""/eg;

#print "$valias --> $vmailto";
if($vmailof eq "" || $vmailto eq "")
{

$okforsave=0;$exmsg="<font color=red><br>Information are not filed properly.</font>";
print "$exmsg";
$in{'fun'}='addalias';
}

if($okforsave==1)
{
$newuser=$vmailof;


$sqlx="SELECT `username`, `password`, `name`, `maildir`, `quota`, `domain`, `created`, `modified`, `active` FROM `mailbox` WHERE `domain`='".$vdomain."' and `username` = '".$newuser."@".$vdomain."' ";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
$okforsave=0;$exmsg="<br> Mailbox ".$newuser."@".$vdomain."  already exists.";
}
$sqlx="SELECT `address`  FROM `alias` WHERE `address` = '".$newuser."@".$vdomain."'  and `address`  NOT IN ( SELECT `username` FROM `mailbox` WHERE `domain` = '".$vdomain."'  ) and `domain` = '".$vdomain."'  ";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
while(($gaddress)=$table_data->fetchrow_array)
{
$okforsave=0;$exmsg="<br> Alias ".$newuser."@".$vdomain."  already exists.";
}


if($okforsave==0)
{
print "<font color=red> ".$exmsg."</font><br> ";
$in{'fun'}='addalias';
}

if($okforsave==1)
{

$sqlx="INSERT INTO `alias` (`address`, `goto`, `domain`, `created`, `modified`, `active`) VALUES ('".$valias."', '".$vmailto."','".$vdomain."', NOW(), NOW(), '1');";
#print "<br>\n$sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;


$exmsg="Alias ".$newuser."@".$vdomain." added successfuly. ";
print "<font color=green> ".$exmsg."</font><br> ";

}

#### all filed ok ##
}

### check of both input done
}

&webmin_log("Powermail", "addalias", "".$valias." Success:".$okforsave." ".$exmsg." ");


}
### Save New Alias -end  ####




### Save updated Alias -start  ####
if($in{'fun'} eq "saveupdatealias")
{
$valiasname=$in{'vusername'};
$okforsave=1;

$sqlin="SELECT `address`, `goto`, `domain`, `created`, `modified`, `active`  FROM `alias` as a  WHERE `domain` = '".$vdomain."' and `address`  NOT IN ( SELECT `username` FROM `mailbox` WHERE `domain` = '".$vdomain."' ) and `address` ='".$in{'vusername'}."'  ";
#print "$sqlin";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$goto,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
$vno++;
$forwardto=$goto;
}
if($vno==0)
{
$exmsg="Not a valid alias : $valiasname in domain $vdomain ";
print "<font color=red> ".$exmsg."</font><br> ";
$in{'fun'}='listalias';
### Webin log of addnew user
&webmin_log("Powermail", "editalias", "".$valias." Success:".$okforsave." ".$exmsg." ");

exit;
}
$vmailto=$in{'forwardto'};
$vmailto=~ s/\n/""/eg;
$vmailto=~ s/\r/""/eg;
$vmailto=~ s/\t/""/eg;
$vmailto=~ s/\\/""/eg;
$vmailto=~ s/'/""/eg;
$vmailto=~ s/"/""/eg;
$vmailto=~ s/\#/""/eg;
$vmailto=~ s/ /""/eg;

if( $vmailto eq "")
{

$okforsave=0;$exmsg="<font color=red><br>Information are not filed properly.</font>";
print "$exmsg";
$in{'fun'}='editalias';
}

if($okforsave==1)
{
$sqlu="UPDATE `alias` SET `goto` = '".$vmailto."', `active` = '".$in{'useractive'}."',`modified`=NOW() WHERE `alias`.`address` = '".$valiasname."' and  domain = '".$vdomain."';";
#print "<br>\n$sqlxu \n"; 
$table_data = $dbh->prepare($sqlu);
$table_data->execute;


$exmsg="Alias ".$valiasname." upated successfuly. ";
print "<font color=green> ".$exmsg."</font><br> ";

}
### Webin log 
&webmin_log("Powermail", "saveupdatealias", "".$newuser." Success:".$okforsave." ".$exmsg." ");

}
### Update Alias -end  ####






####### Add Alias Page --start
if($in{'fun'} eq "addalias")
{
print "<br>";
print ui_table_start('Add a new Email Alias @'.$vdomain, undef, 2);
print ui_table_row('Forward mails of',ui_textbox('vmailof', $in{'vmailof'}, 40).'@'.$in{'vpopmaildomain'}.'');
print ui_table_row('To destination email',ui_textbox('vmailto', $in{'vmailto'}, 40).'(Full email address)<br>
Example : <b>  newuser@'.$vdomain.'</b>, Add only One email id first, latter update with multiple address using edit feature.');
print ui_hidden('fun', 'savenewalias', 40);
print ui_table_row('&nbsp;',ui_submit('Add new email alias', 'fun2'));

 print ui_table_end();

}
####### Add Alias Page --end





####### Edit Alias Page --start
if($in{'fun'} eq "editalias")
{
$valiasname=$in{'vusername'};


$sqlin="SELECT `address`, `goto`, `domain`, `created`, `modified`, `active`  FROM `alias` as a  WHERE `domain` = '".$vdomain."' and `address`  NOT IN ( SELECT `username` FROM `mailbox` WHERE `domain` = '".$vdomain."' ) and `address` ='".$in{'vusername'}."'  ";
#print "$sqlin";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
$useractive=0;
while(($guser,$goto,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
$vno++;
$forwardto=$goto;
$useractive=$gact;
}
if($vno==0)
{
$exmsg="Not a valid alias : $valiasname in domain $vdomain ";
print "<font color=red> ".$exmsg."</font><br> ";
$in{'fun'}='listalias';
### Webin log of addnew user
&webmin_log("Powermail", "editalias", "".$valias." Success:".$okforsave." ".$exmsg." ");

exit;
}
print "<br>";
print ui_table_start('Edit Email Alias '.$valiasname, undef, 2);

print ui_table_row('To destination email(s)',ui_textarea('forwardto', $forwardto, 5,40).'Full email address, with comma sepreate ');
print ui_table_row('Account Active',ui_checkbox('useractive', '1','',$useractive).' By un-checking this box account is disable.');

print ui_hidden('fun', 'saveupdatealias', 40);
print ui_hidden('vusername', $in{'vusername'}, 40);
print ui_table_row('&nbsp;',ui_submit('Save Email Alias', 'fun2'));

print ui_table_row('&nbsp;',ui_button('Delete Alias', 'fun2',undef,'onClick=delalias();return false;"'));

 print ui_table_end();

}
####### Edit Alias Page --end




####### search user Page --start
if($in{'fun'} eq "searchuser")
{
print "<br>";
print ui_table_start('Search Email User @'.$vdomain, undef, 2);
print ui_table_row('Enter some text for username search',ui_textbox('susername', $in{'susername'}, 40));
print ui_hidden('fun', 'listuser', 40);
print ui_table_row('&nbsp;',ui_submit('Search email user', 'fun2'));

 print ui_table_end();

}
####### search user Page --end



#### Delete User page --start
if($in{'fun'} eq "deleteuser" && $in{'vusername'} ne "" )
{
$okforsave=1;
$newuser=$in{'vusername'};

$sqlx="DELETE FROM `alias` WHERE `address` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$sqlx="DELETE FROM `mailbox` WHERE `username` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$sqlx="DELETE FROM `powermailbox` WHERE `username` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$exmsg= "<br><br><font color=green>User  : ".$newuser." deleted successfully.</font>";
print $exmsg;
&webmin_log("Powermail", "deleteuser", "".$newuser." Success:".$okforsave."");

}
#### Delete User page --end


#### Delete User page --start
if($in{'fun'} eq "deletelist" && $in{'vusername'} ne "" )
{
$okforsave=1;
$newuser=$in{'vusername'};

$sqlx="DELETE FROM `alias` WHERE `address` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$sqlx="DELETE FROM `mailbox` WHERE `username` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$sqlx="DELETE FROM `powermailbox` WHERE `username` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$sqlx="DELETE FROM `powermaillist` WHERE `address` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$exmsg= "<br><br><font color=green>Group Mailling List  : ".$newuser." deleted successfully.</font>";
print $exmsg;
&webmin_log("Powermail", "deletelist", "".$newuser." Success:".$okforsave."");

}
#### Delete User page --end



#### Delete Alias page --start
if($in{'fun'} eq "deletealias" && $in{'vusername'} ne "" )
{
#print "delete alias done";

$sqlx="DELETE FROM `alias` WHERE `address` = '".$in{'vusername'}."'";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$exmsg= "<br><br><font color=green>Alias  : ".$in{'vusername'}." deleted successfully.</font>";
print $exmsg;

&webmin_log("Powermail", "deletealias", "".$in{'vusername'}." Success:".$okforsave."");

}
#### Delete Alias page --end

#### Update User page --start
if($in{'fun'} eq "updateuser" && $in{'vusername'} ne "" )
{
$okforsave=1;
$newuser=$in{'vusername'};
$newpass=$in{'vuserpass'};
$vquotalimit=$in{'vuserdiskquota'};
$newpasscheck=$in{'vuserpasscheck'};
#$newpass=~ s/\"/"\\\""/eg;
#$newpasscheck=~ s/\"/"\\\""/eg;
if($newuser eq ""){$okforsave=0;}
if($newpass ne $newpasscheck && $newpass ne "" &&  $newpasscheck ne ""){$okforsave=0;$exmsg="<br>Password re-enter is not correct.";}
$newnamex=$in{'fullname'};
$newnamex=~ s/\n/""/eg;
$newnamex=~ s/\r/""/eg;
$newnamex=~ s/\t/""/eg;
$newnamex=~ s/\\/""/eg;
$newnamex=~ s/'/""/eg;
$newnamex=~ s/"/""/eg;
$newnamex=~ s/\#/""/eg;

$vpassword="";
$vsql="";

if($newpass eq $newpasscheck && $newpass ne "" &&  $newpasscheck ne "")
{
$vpassword=$newpass;
$vpassword=~ s/'/""/eg;
$vsql="`password` ='".$vpassword."', ";
}
if($in{'useractive'} eq ""){$in{'useractive'}="0";}
$vuserdisk=$in{'vuserdiskquota'} * $in{'vuserdiskquota_units'} ;
#print " --> ".$in{'vuserdiskquota'} ." -->".$in{'vuserdiskquota_units'}." --> ".$vuserdisk;

$sqlu="UPDATE `mailbox` SET ".$vsql." `name` = '".$newnamex."', `quota` = '".$vuserdisk."', `modified` = NOW(), `active` = '".$in{'useractive'}."' WHERE `mailbox`.`username` = '".$in{'vusername'}."' and `domain` = '".$vdomain."';";
#print "$sqlu <br>";
$table_data = $dbh->prepare($sqlu);
$table_data->execute;

$sqlu="UPDATE `powermailbox` SET `autoclean_trash` = '".$in{'auto_clean_trash'}."', `autoclean_spam` = '".$in{'auto_clean_spam'}."', `autoclean_promo` = '".$in{'auto_clean_promo'}."', `change_pass_max_days` = '".$in{'change_pass_max_days'}."', `change_pass_alerts_before_days` = '".$in{'change_pass_alerts_before_days'}."' WHERE `powermailbox`.`username` = '".$in{'vusername'}."';";
#print "$sqlu <br>";
$table_data = $dbh->prepare($sqlu);
$table_data->execute;

$forwardsave=$in{'forwardsave'};
$vmailof=$in{'forwardto'};
$vmailof=~ s/\n/""/eg;
$vmailof=~ s/\r/""/eg;
$vmailof=~ s/\t/""/eg;
$vmailof=~ s/\\/""/eg;
$vmailof=~ s/'/""/eg;
$vmailof=~ s/"/""/eg;
$vmailof=~ s/\#/""/eg;
$vmailof=~ s/ /""/eg;

$valiasz="";
if($vmailof ne ""){
if( $forwardsave ne "" ){$valiasz=$valiasz.$in{'vusername'}.",";}
$valiasz=$valiasz."";
$valiasz=$valiasz.$vmailof;
}

if($vmailof eq ""){ $valiasz=$in{'vusername'};}

$sqlu="UPDATE `alias` SET `goto` = '".$valiasz."', `active` = '".$in{'useractive'}."',`modified`=NOW() WHERE `alias`.`address` = '".$in{'vusername'}."' and  domain = '".$vdomain."';";
#print "<br>\n$sqlu \n";
$table_data = $dbh->prepare($sqlu);
$table_data->execute;


$exmsg="User ".$in{'vusername'}." update successfuly. ";
print "<font color=green> ".$exmsg."</font><br> ";


#print "user updated";
### Webin log of updateuser
&webmin_log("Powermail", "updateuser", "".$newuser."\@".$in{'vpopmaildomain'}." Success:".$okforsave."");



}
#### Update User page --end


####### Edit user Page --start
if($in{'fun'} eq "edituser" && $in{'vusername'} ne "" )
{

$p2sql="INSERT INTO `powermailbox` (`username`) VALUES ('".$in{'vusername'}."');";
#print "$p2sql ";
$p2table_data = $dbh->prepare($p2sql);
$p2table_data->execute;


$sqlin="SELECT a.`username`, a.`password`, a.`name`, a.`maildir`, a.`quota`, a.`domain`, a.`created`, a.`modified`, a.`active`,b.`autoclean_trash`, b.`autoclean_spam`, b.`autoclean_promo`, b.`change_pass_max_days`, b.`change_pass_alerts_before_days`, FROM_UNIXTIME(b.`lastlogintime`), b.`lastloginip`,b.`deliveryto`  FROM `mailbox`  as a LEFT JOIN `powermailbox` as b ON a.`username` = b.`username`  where  a.`domain` = '".$vdomain."' and a.`username` ='".$in{'vusername'}."' ";


#print " -- $sqlin";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
$maildirpath="";
$maildirpath1="";
$msize="";
$mpass="";
$ltimeshow="";
$lastfrom="";
$auto_clean_trash=0;
$auto_clean_spam=0;
$auto_clean_promo=0;
$change_pass_max_days=0;
$change_pass_alerts_before_days=0;
$useractive=0;
$deliverytox="local";
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact,$atrash,$aspam,$apromo,$passmax,$passalert,$lasttime,$lastip,$deli)=$table_data->fetchrow_array)
{
$fullname=$gname;
$deliverytox=$deli;
#$mpass=$gpass;
$maildirpath=$gmaildir."Maildir/";
$maildirpath1=$gmaildir;
$msize=$gquota;
$remote_ip=$lasttime;
if($remote_ip ne "" ){$remote_ip=$lasttime;}
if($remote_ip eq "1970-01-01 05:30:00" ){$remote_ip="Never logged in";}
if($remote_ip eq "1970-01-01 00:00:00" ){$remote_ip="Never logged in";}
$ltimeshow=$remote_ip;
if($atrash eq ""){$atrash=0;}
if($aspam eq ""){$aspam=0;}
if($apromo eq ""){$apromo=0;}
if($passmax eq ""){$passmax=0;}
if($passalert eq ""){$passalert=0;}
$auto_clean_trash=$atrash;
$auto_clean_spam=$aspam;
$auto_clean_promo=$apromo;
$change_pass_max_days=$passmax;
$change_pass_alerts_before_days=$passalert;
$useractive=$gact;
##while over

}


$sqlin="SELECT `address`, `goto`, `domain`, `created`, `modified`, `active`  FROM `alias` as a  WHERE `domain` = '".$vdomain."' and `address` ='".$in{'vusername'}."'  ";

##print " -- $sqlin";
$forwardsave="";
$forwardto="";

$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$goto,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
if($goto ne $in{'vusername'} )
{
$gotox=$goto;
$gotox=~ s/$in{'vusername'},/""/eg;
if($gotox ne $goto){ $forwardsave="yes";}
$forwardto=$gotox;
}

}

print "<br>";
print ui_table_start('Modify Email User '.$in{'vusername'}, undef, 2);
print ui_table_row('Email Address ',$in{'vusername'});
print ui_table_row('MailDir Path ','/home/powermail/domains/'.$maildirpath);
print ui_table_row('Last-Login',$ltimeshow);
print ui_table_row('Full Name / Info',ui_textbox('fullname', $fullname, 40));
print ui_table_row('Enter new password',ui_password('vuserpass', $mpass, 40));
print ui_table_row('Enter new password again',ui_password('vuserpasscheck', $mpass, 40));
#####print ui_table_row('Disk Quota [NOQUOTA means Unlimited]',ui_textbox('vuserdiskquota', $msize, 40).' bytes (1073741824 bytes = 1GB)');
print ui_table_row('Disk Quota [0 means Unlimited]',ui_bytesbox('vuserdiskquota', $msize, 40).' bytes (1073741824 bytes = 1GB or 1024MB = 1GB)');
my @opts=('local','other');
print ui_table_row('Delivery Mail to ',ui_select('vuserdelivetyto', $deliverytox,\@opts,1,0,0,0,"").' Server ');

print ui_table_row('Auto Clean Mail from Trash folder after ',ui_textbox('auto_clean_trash', $auto_clean_trash, 10).' <strong>Days</strong> (0  = disable, e.g: 30 days)');
print ui_table_row('Auto Clean Mail from Spam folder after ',ui_textbox('auto_clean_spam', $auto_clean_spam, 10).' <strong>Days</strong> (0  = disable, e.g: 30 days)');
print ui_table_row('Auto Clean Mail from Promotional folder after ',ui_textbox('auto_clean_promo', $auto_clean_promo, 10).'<strong>Days</strong> (0  = disable, e.g.: 30 days)');
print ui_table_row('Change Password in ',ui_textbox('change_pass_max_days', $change_pass_max_days, 10).'<strong>Days</strong> else force autogenerate and change password.(0  = disable, e.g.: 90 days) ');
print ui_table_row('Alert for Change Password ',ui_textbox('change_pass_alerts_before_days', $change_pass_alerts_before_days, 10).'<strong>Days</strong> before and than send daily once.(0  = disable, e.g.: 7 days)');



print ui_table_row('While Forward save a copy in Inbox',ui_checkbox('forwardsave', 'yes','',$forwardsave).' Save also in Inbox (By checking this box)');
print ui_table_row('Forward To another Email-Address',ui_textarea('forwardto', $forwardto, 5,40).'Full email address, with comma sepreate  ');
print ui_table_row('Account Active',ui_checkbox('useractive', '1','',$useractive).' By un-checking this box account is disabled but data is intake.');

print ui_hidden('fun', 'updateuser', 40);
print ui_hidden('vusername', $in{'vusername'}, 40);

#print ui_table_row('&nbsp;',ui_submit('Update user', 'fun2'));

print ui_table_row('&nbsp;',"<input type='submit' name='show1' value='Update User' onClick='return Val_pass(\"".$vdomain."\");'>");

if($in{'vusername'} ne "postmaster"){
print ui_table_row('&nbsp;',ui_button('Delete user', 'fun2',undef,'onClick=deluser();return false;"'));
}
 print ui_table_end();



}
####### Add user Page --end



### View User List --start
if($in{'fun'} eq "listuser")
{
$ssql="";
if($in{'susername'} ne ""){
$ssql="and a.username like '%".$in{'susername'}."%' ";
$snotes=" [search for ".$in{'susername'}."]";}
print "<br>";
print ui_table_start('List of Email-Users @ '.$vdomain." ".$snotes,'width=100% align=center', 2);
$uord="ASC";
$qord="ASC";
$lord="ASC";
$cord="ASC";
$mord="ASC";
$aord="ASC";
$orderby="DESC";
$colname="username";
if($in{'colname'} eq "" ){$uord="DESC";$orderby="ASC";$colname="a.username"; }
if($in{'colname'} eq "username" &&  $in{'orderby'} eq "ASC"){$uord="DESC";$orderby="ASC";$colname="a.username"; }
if($in{'colname'} eq "quota" &&  $in{'orderby'} eq "ASC"){$qord="DESC";$orderby="ASC";$colname="a.quota"; }
if($in{'colname'} eq "lastlogintime" &&  $in{'orderby'} eq "ASC"){$lord="DESC";$orderby="ASC";$colname="b.lastlogintime"; }
if($in{'colname'} eq "created" &&  $in{'orderby'} eq "ASC"){$cord="DESC";$orderby="ASC";$colname="a.created"; }
if($in{'colname'} eq "modified" &&  $in{'orderby'} eq "ASC"){$mord="DESC";$orderby="ASC";$colname="a.modified"; }
if($in{'colname'} eq "active" &&  $in{'orderby'} eq "ASC"){$aord="DESC";$orderby="ASC";$colname="a.active"; }
if($in{'colname'} eq "deliveryto" &&  $in{'orderby'} eq "ASC"){$aord="DESC";$orderby="ASC";$colname="b.deliveryto"; }


if($in{'colname'} eq "username" &&  $in{'orderby'} eq "DESC"){$uord="ASC";$orderby="DESC";$colname="a.username"; }
if($in{'colname'} eq "quota" &&  $in{'orderby'} eq "DESC"){$qord="ASC";$orderby="DESC";$colname="a.quota"; }
if($in{'colname'} eq "lastlogintime" &&  $in{'orderby'} eq "DESC"){$lord="ASC";$orderby="DESC";$colname="b.lastlogintime"; }
if($in{'colname'} eq "created" &&  $in{'orderby'} eq "DESC"){$cord="ASC";$orderby="DESC";$colname="a.created"; }
if($in{'colname'} eq "modified" &&  $in{'orderby'} eq "DESC"){$mord="ASC";$orderby="DESC";$colname="a.modified"; }
if($in{'colname'} eq "active" &&  $in{'orderby'} eq "DESC"){$aord="ASC";$orderby="DESC";$colname="a.active"; }
if($in{'colname'} eq "deliveryto" &&  $in{'orderby'} eq "DESC"){$aord="ASC";$orderby="DESC";$colname="a.deliveryto"; }


$user_url='<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=username&orderby='.$uord.'&susername='.$in{'susername'}.'\'>Username</a>';
$quota_url='<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=quota&orderby='.$qord.'&susername='.$in{'susername'}.'\'>Quota (Bytes)</a>';
$last_url='<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=lastlogintime&orderby='.$lord.'&susername='.$in{'susername'}.'\'>Last-Login</a>';
$create_url='<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=created&orderby='.$cord.'&susername='.$in{'susername'}.'\'>Created on</a>';
$mod_url='<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=modified&orderby='.$mord.'&susername='.$in{'susername'}.'\'>Modified on</a>';
$act_url='<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=active&orderby='.$mord.'&susername='.$in{'susername'}.'\'>Active</a>';
$deli_url='<a href=\'index.cgi?fun=listuser&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=deliveryto&orderby='.$mord.'&susername='.$in{'susername'}.'\'>Delivery</a>';

print &ui_columns_start(['No.',$user_url,$quota_url,$last_url,$create_url,$mod_url,$act_url,$deli_url]);

####$sqlin="SELECT `username`, `password`, `name`, `maildir`, `quota`, `domain`, `created`, `modified`, `active` FROM `mailbox` WHERE `domain` = '".$in{'vpopmaildomain'}."' ".$ssql." order by `".$colname."` ".$orderby." ";

$sqlin="SELECT a.`username`, a.`password`, a.`name`, a.`maildir`, a.`quota`, a.`domain`, a.`created`, a.`modified`, a.`active`,b.`autoclean_trash`, b.`autoclean_spam`, b.`autoclean_promo`, b.`change_pass_max_days`, b.`change_pass_alerts_before_days`, FROM_UNIXTIME(b.`lastlogintime`), b.`lastloginip`,b.`deliveryto`  FROM `mailbox`  as a LEFT JOIN `powermailbox` as b ON a.`username` = b.`username`  where  a.`domain` = '".$vdomain."' ".$ssql." order by ".$colname." ".$orderby."  ";

#print " -- $sqlin";

$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact,$atrash,$aspam,$apromo,$passmax,$passalert,$lasttime,$lastip,$deli)=$table_data->fetchrow_array)
{
$vno++;
if($atrash eq "")
{
$p2sql="INSERT INTO `powermailbox` (`username`) VALUES ('".$guser."');";
$p2table_data = $dbh->prepare($p2sql);
$p2table_data->execute;

}
$gact2="NO";
if($gact == 1){$gact2="YES";}
$remote_ip=$lasttime;
if($remote_ip ne "" ){$remote_ip=$lasttime;}
if($remote_ip eq "1970-01-01 05:30:00" ){$remote_ip="Never logged in";}
if($remote_ip eq "1970-01-01 00:00:00" ){$remote_ip="Never logged in";}

$guser2=$guser;
$guser2="<a href=\"index.cgi?vpopmaildomain=".$in{'vpopmaildomain'}."&fun=edituser&vusername=".$guser."&\">".$guser."</a>";
$ltime=$remote_ip;
$ctime=$gcreate;
$mtime=$gmod;
print &ui_columns_row([$vno,$guser2,$gquota,$ltime,$ctime,$mtime,$gact2,$deli]);
}
print &ui_columns_end();

print ui_table_end();

}
### View User List --end


#### saveupdatelist start
if($in{'fun'} eq "saveupdatelist")
{
$okforsave=1;
$valias=$in{'vusername'};
$sqlin="SELECT `address`,`info`, `member`, `owner`, `domain`, `created`, `modified`, `active`, `sendtype` FROM `powermaillist` as a  WHERE `domain` = '".$vdomain."' and `address` ='".$in{'vusername'}."'   ";

#print "$sqlin";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
$useractive=0;
while(($guser,$ginfo,$gmem,$gown,$gdom,$gcreate,$gmod,$gact,$gsend)=$table_data->fetchrow_array)
{
$vno++;
$vmember=$gmem;
$vowner=$gown;
$fullinfo=$ginfo;
$sendtype=$gsend;
$useractive=$gact;

}
if($vno==0)
{
$exmsg="Not a valid group list : $valiasname in domain $vdomain ";
print "<font color=red> ".$exmsg."</font><br> ";
$in{'fun'}='editlist';
### Webin log of addnew user
&webmin_log("Powermail", "saveupdatelist", "".$valias." Success:".$okforsave." ".$exmsg." ");

exit;
}

$vmailof=$in{'vmember'};
$vmailof=~ s/\n/""/eg;
$vmailof=~ s/\r/""/eg;
$vmailof=~ s/\t/""/eg;
$vmailof=~ s/\\/""/eg;
$vmailof=~ s/'/""/eg;
$vmailof=~ s/"/""/eg;
$vmailof=~ s/\#/""/eg;
$vmailof=~ s/ /""/eg;
$vmailto=$in{'vowner'};
$vmailto=~ s/\n/""/eg;
$vmailto=~ s/\r/""/eg;
$vmailto=~ s/\t/""/eg;
$vmailto=~ s/\\/""/eg;
$vmailto=~ s/'/""/eg;
$vmailto=~ s/"/""/eg;
$vmailto=~ s/\#/""/eg;
$vmailto=~ s/ /""/eg;
if($in{'useractive'} eq ""){$in{'useractive'}="0";}
$sqlu="UPDATE `powermaillist` SET `member` = '".$vmailof."', `owner` = '".$vmailto."', `active` = '".$in{'useractive'}."', `sendtype` ='".$in{'sendtype'}."', `modified`=NOW() WHERE `address` = '".$valias."' and  domain = '".$vdomain."';";
#print "<br>\n$sqlu \n";
$table_data = $dbh->prepare($sqlu);
$table_data->execute;

$exmsg="Group Mailling List ".$valias." updated successfuly. ";
print "<font color=green> ".$exmsg."</font><br> ";

#print "saveupdatelist";

&webmin_log("Powermail", "saveupdatelist", "".$valias." Success:".$okforsave." ".$exmsg." ");

}
## saveupdatelist --end



## edit list page start 
if($in{'fun'} eq "editlist")
{
$valiasname=$in{'vusername'};

$sqlin="SELECT a.`username`, a.`password`, a.`name`, a.`maildir`, a.`quota`, a.`domain`, a.`created`, a.`modified`, a.`active`,b.`autoclean_trash`, b.`autoclean_spam`, b.`autoclean_promo`, b.`change_pass_max_days`, b.`change_pass_alerts_before_days`, b.`lastlogintime`, b.`lastloginip`  FROM `mailbox`  as a LEFT JOIN `powermailbox` as b ON a.`username` = b.`username`  where  a.`domain` = '".$vdomain."' and a.`username` ='".$in{'vusername'}."' ";

#print " $sqlin ";
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact,$atrash,$aspam,$apromo,$passmax,$passalert,$lasttime,$lastip)=$table_data->fetchrow_array)
{
## noting from user table as of now
}


$sqlin="SELECT `address`,`info`, `member`, `owner`, `domain`, `created`, `modified`, `active`, `sendtype` FROM `powermaillist` as a  WHERE `domain` = '".$vdomain."' and `address` ='".$in{'vusername'}."'   ";

#print "$sqlin";
$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
$useractive=0;
while(($guser,$ginfo,$gmem,$gown,$gdom,$gcreate,$gmod,$gact,$gsend)=$table_data->fetchrow_array)
{
$vno++;
$vmember=$gmem;
$vowner=$gown;
$fullinfo=$ginfo;
$sendtype=$gsend;
$useractive=$gact;

}
if($vno==0)
{
$exmsg="Not a valid group list : $valiasname in domain $vdomain ";
print "<font color=red> ".$exmsg."</font><br> ";
$in{'fun'}='managelist';
### Webin log of addnew user
&webmin_log("Powermail", "editlist", "".$valias." Success:".$okforsave." ".$exmsg." ");

exit;
}
print "<br>";
print ui_table_start('Edit Group Mailling List '.$valiasname, undef, 2);
print ui_table_row('Fullname / Info',ui_textbox('fullinfo', $fullinfo, 40).'');
print ui_table_row('Members (Subscribers)',ui_textarea('vmember', $vmember, 5,40).'Full email address, with comma sepreate ');
print ui_table_row('Owner (Moderator)',ui_textarea('vowner', $vowner, 5,40).'Full email address, with comma sepreate ');
$sel1="";
$sel2="";
$sel3="";
$sel4="";

if($sendtype eq "ANYONE"){$sel1="selected";}
if($sendtype eq "MEMBERS"){$sel2="selected";}
if($sendtype eq "OWNERS"){$sel3="selected";}
if($sendtype eq "MEMBERS_AND_OWNERS"){$sel4="selected";}
$selx="";
$selx=$selx."<select name=\"sendtype\">";
$selx=$selx."<option value=\"ANYONE\" ".$sel1.">AnyOne can send</option>";
$selx=$selx."<option value=\"MEMBERS\" ".$sel2.">Members Only</option>";
$selx=$selx."<option value=\"OWNERS\" ".$sel3.">Owners Only</option>";
$selx=$selx."<option value=\"MEMBERS_AND_OWNERS\" ".$sel4.">Owners & Members Only</option>";
$selx=$selx."</select>";
print ui_table_row('Sender Type',$selx,1);



print ui_table_row('Account Active',ui_checkbox('useractive', '1','',$useractive).' By un-checking this box account/group is disable.');

print ui_hidden('fun', 'saveupdatelist', 40);
print ui_hidden('vusername', $in{'vusername'}, 40);
print ui_table_row('&nbsp;',ui_submit('Save Group Mailing List', 'fun2'));

print ui_table_row('&nbsp;',ui_button('Delete Group Mailing List', 'fun2',undef,'onClick=dellist();return false;"'));
 print ui_table_end();

}

## edit list page end 





### View mailling List --start
if($in{'fun'} eq "managelist")
{


$ssql="";
if($in{'susername'} ne ""){
$ssql="and a.username like '%".$in{'susername'}."%' ";
$snotes=" [search for ".$in{'susername'}."]";}
print "<br>";
print ui_table_start('List of Group Mailling  @ '.$vdomain." ".$snotes,'width=100% align=center', 2);
$uord="ASC";
$qord="ASC";
$lord="ASC";
$cord="ASC";
$mord="ASC";
$aord="ASC";
$gord="ASC";
$oord="ASC";
$sord="ASC";
$orderby="DESC";
$colname="address";
if($in{'colname'} eq "" ){$uord="DESC";$orderby="ASC";$colname="a.address"; }
if($in{'colname'} eq "address" &&  $in{'orderby'} eq "ASC"){$uord="DESC";$orderby="ASC";$colname="a.address"; }
if($in{'colname'} eq "created" &&  $in{'orderby'} eq "ASC"){$cord="DESC";$orderby="ASC";$colname="a.created"; }
if($in{'colname'} eq "modified" &&  $in{'orderby'} eq "ASC"){$mord="DESC";$orderby="ASC";$colname="a.modified"; }
if($in{'colname'} eq "active" &&  $in{'orderby'} eq "ASC"){$aord="DESC";$orderby="ASC";$colname="a.active"; }
if($in{'colname'} eq "goto" &&  $in{'orderby'} eq "ASC"){$gord="DESC";$orderby="ASC";$colname="a.goto"; }
if($in{'colname'} eq "owner" &&  $in{'orderby'} eq "ASC"){$goord="DESC";$orderby="ASC";$colname="a.owner"; }
if($in{'colname'} eq "sendtype" &&  $in{'orderby'} eq "ASC"){$sord="DESC";$orderby="ASC";$colname="a.sendtype"; }


if($in{'colname'} eq "address" &&  $in{'orderby'} eq "DESC"){$uord="ASC";$orderby="DESC";$colname="a.address"; }
if($in{'colname'} eq "created" &&  $in{'orderby'} eq "DESC"){$cord="ASC";$orderby="DESC";$colname="a.created"; }
if($in{'colname'} eq "modified" &&  $in{'orderby'} eq "DESC"){$mord="ASC";$orderby="DESC";$colname="a.modified"; }
if($in{'colname'} eq "active" &&  $in{'orderby'} eq "DESC"){$aord="ASC";$orderby="DESC";$colname="a.active"; }
if($in{'colname'} eq "goto" &&  $in{'orderby'} eq "DESC"){$gord="ASC";$orderby="DESC";$colname="a.goto"; }
if($in{'colname'} eq "owner" &&  $in{'orderby'} eq "DESC"){$oord="ASC";$orderby="DESC";$colname="a.owner"; }
if($in{'colname'} eq "sendtype" &&  $in{'orderby'} eq "DESC"){$sord="ASC";$orderby="DESC";$colname="a.sendtype"; }


$user_url='<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=address&orderby='.$uord.'&susername='.$in{'susername'}.'\'>Group Maillist</a>';
$create_url='<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=created&orderby='.$cord.'&susername='.$in{'susername'}.'\'>Created on</a>';
$mod_url='<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=modified&orderby='.$mord.'&susername='.$in{'susername'}.'\'>Modified on</a>';
$act_url='<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=active&orderby='.$mord.'&susername='.$in{'susername'}.'\'>Active</a>';
$goto_url='<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=member&orderby='.$gord.'&susername='.$in{'susername'}.'\'>Members(Subscribers)</a>';
$owner_url='<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=owner&orderby='.$oord.'&susername='.$in{'susername'}.'\'>Owners(Moderators)</a>';
$sender_url='<a href=\'index.cgi?fun=managelist&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=sendtype&orderby='.$sord.'&susername='.$in{'susername'}.'\'>Sender Type</a>';


print &ui_columns_start(['No.',$user_url,$goto_url,$owner_url,$sender_url,$create_url,$mod_url,$act_url]);




$sqlin="SELECT `address`,`info`, `member`, `owner`, `domain`, `created`, `modified`, `active`, `sendtype` FROM `powermaillist` as a  WHERE `domain` = '".$vdomain."' ".$ssql." order by ".$colname." ".$orderby."  ";
#print " -- $sqlin";

$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$ginfo,$goto,$gown,$gdom,$gcreate,$mtime,$gact,$gsend)=$table_data->fetchrow_array)
{
$vno++;
$gact2="NO";
if($gact == 1){$gact2="YES";}
$guser2=$guser;
$guser2="<a href=\"index.cgi?vpopmaildomain=".$in{'vpopmaildomain'}."&fun=editlist&vusername=".$guser."&\">".$guser."</a>";
$ctime=$gcreate;
##$goto=~ s/,/",<br>"/eg;

if($show_goto_address==0)
{
@zaqlist=();@zaqlist=split/,/,$goto;$gotox=0;
$goto = @zaqlist;
@zzaqlist=();@zzaqlist=split/,/,$gown;$gownx=0;
$gown = @zzaqlist;

}

if($show_goto_address==1)
{
$goto=~ s/,/",<br>"/eg;
$gown=~ s/,/",<br>"/eg;
}

print &ui_columns_row([$vno,$guser2,$goto,$gown,$gsend,$ctime,$mtime,$gact2]);
}
print &ui_columns_end();

print ui_table_end();



}

### View Mail List --end



####### Add list name --start
if($in{'fun'} eq "savenewlist")
{
$okforsave=1;
$vmailof=$in{'vnewlist'};
$vmailof=~ s/\n/""/eg;
$vmailof=~ s/\r/""/eg;
$vmailof=~ s/\t/""/eg;
$vmailof=~ s/\\/""/eg;
$vmailof=~ s/'/""/eg;
$vmailof=~ s/"/""/eg;
$vmailof=~ s/\#/""/eg;
$vmailof=~ s/ /""/eg;
$newuser=$vmailof;
$valias=$vmailof."@".$in{'vpopmaildomain'};
if($vmailof eq "" )
{
$okforsave=0;$exmsg="<font color=red><br>Information are not filed properly.</font>";
print "$exmsg";
$in{'fun'}='addlist';
}

if($okforsave==1)
{
$newuser=$vmailof;


$sqlx="SELECT `username`, `password`, `name`, `maildir`, `quota`, `domain`, `created`, `modified`, `active` FROM `mailbox` WHERE `domain`='".$vdomain."' and `username` = '".$newuser."@".$vdomain."' ";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
while(($guser,$gpass,$gname,$gmaildir,$gquota,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
$okforsave=0;$exmsg="<br> Mailbox ".$newuser."@".$vdomain."  already exists.";
}
$sqlx="SELECT `address`  FROM `alias` WHERE `address` = '".$newuser."@".$vdomain."'  and `address`  NOT IN ( SELECT `username` FROM `mailbox` WHERE `domain` = '".$vdomain."'  ) and `domain` = '".$vdomain."'  ";
#print "\n $sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;
while(($gaddress)=$table_data->fetchrow_array)
{
$okforsave=0;$exmsg="<br> Alias ".$newuser."@".$vdomain."  already exists.";
}


if($okforsave==0)
{
print "<font color=red> ".$exmsg."</font><br> ";
$in{'fun'}='addlist';
}

if($okforsave==1)
{
$vuserdisk=0;
$newin=$newuser."@".$vdomain;
$userx=$newuser;
$domaingot=$vdomain;
$newpass=`pwgen -n 8`;
$in{'vuserfullname'}="Group Maillinglist ".$newuser;
$sqlx="INSERT INTO `mailbox` (`username`, `password`, `name`, `maildir`, `quota`, `local_part`, `domain`, `created`, `modified`, `active`) VALUES ('".$newin."', '".$newpass."', '".$in{'vuserfullname'}."', '".$domaingot."/".$userx."/', '".$vuserdisk."', '".$userx."', '".$domaingot."', NOW(), NOW(), '1');";

#print "<hr>\n$sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$sqlx="INSERT INTO `alias` (`address`, `goto`, `domain`, `created`, `modified`, `active`) VALUES ('".$newin."', '".$newin."','".$domaingot."', NOW(), NOW(), '1');";
#print "<hr>\n$sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;

$vpost="postmaster\@".$vdomain;
$sqlx="INSERT INTO `powermaillist` (`address`, `info`, `member`, `owner`, `domain`, `created`, `modified`, `active`, `sendtype`) VALUES ('".$newin."', '".$in{'vuserfullname'}."', '".$vpost."', '".$vpost."', '".$vdomain."', NOW(), NOW(), '1', 'ANYONE');";
#print "<hr>\n$sqlx \n";
$table_data = $dbh->prepare($sqlx);
$table_data->execute;


$exmsg="Group Mailling List ".$newuser."@".$vdomain." added successfuly. ";
print "<font color=green> ".$exmsg."</font><br> ";
}



######  if input ok
}
#print "save new list";

&webmin_log("Powermail", "savenewlist", "".$valias." Success:".$okforsave." ".$exmsg." ");

}
##### new List added --end




####### Add mailing list Page --start
if($in{'fun'} eq "addlist")
{
print "<br>";
print ui_table_start('Add a new Group Mailling List  @'.$vdomain, undef, 2);
print ui_table_row('New List name',ui_textbox('vnewlist', $in{'vnewlist'}, 40).'@'.$vdomain);
print ui_hidden('fun', 'savenewlist', 40);
print ui_table_row('&nbsp;',ui_submit('Add new mailing list', 'fun2'));

 print ui_table_end();

}
####### Add maling list Page --end




### View alias List --start
if($in{'fun'} eq "listalias")
{

$ssql="";
if($in{'susername'} ne ""){
$ssql="and a.username like '%".$in{'susername'}."%' ";
$snotes=" [search for ".$in{'susername'}."]";}
print "<br>";
print ui_table_start('List of Email-Alias @ '.$vdomain." ".$snotes,'width=100% align=center', 2);
$uord="ASC";
$qord="ASC";
$lord="ASC";
$cord="ASC";
$mord="ASC";
$aord="ASC";
$gord="ASC";
$orderby="DESC";
$colname="address";
if($in{'colname'} eq "" ){$uord="DESC";$orderby="ASC";$colname="a.address"; }
if($in{'colname'} eq "address" &&  $in{'orderby'} eq "ASC"){$uord="DESC";$orderby="ASC";$colname="a.address"; }
if($in{'colname'} eq "created" &&  $in{'orderby'} eq "ASC"){$cord="DESC";$orderby="ASC";$colname="a.created"; }
if($in{'colname'} eq "modified" &&  $in{'orderby'} eq "ASC"){$mord="DESC";$orderby="ASC";$colname="a.modified"; }
if($in{'colname'} eq "active" &&  $in{'orderby'} eq "ASC"){$aord="DESC";$orderby="ASC";$colname="a.active"; }
if($in{'colname'} eq "goto" &&  $in{'orderby'} eq "ASC"){$gord="DESC";$orderby="ASC";$colname="a.goto"; }


if($in{'colname'} eq "address" &&  $in{'orderby'} eq "DESC"){$uord="ASC";$orderby="DESC";$colname="a.address"; }
if($in{'colname'} eq "created" &&  $in{'orderby'} eq "DESC"){$cord="ASC";$orderby="DESC";$colname="a.created"; }
if($in{'colname'} eq "modified" &&  $in{'orderby'} eq "DESC"){$mord="ASC";$orderby="DESC";$colname="a.modified"; }
if($in{'colname'} eq "active" &&  $in{'orderby'} eq "DESC"){$aord="ASC";$orderby="DESC";$colname="a.active"; }
if($in{'colname'} eq "goto" &&  $in{'orderby'} eq "DESC"){$gord="ASC";$orderby="DESC";$colname="a.goto"; }


$user_url='<a href=\'index.cgi?fun=listalias&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=address&orderby='.$uord.'&susername='.$in{'susername'}.'\'>Email Alias</a>';
$create_url='<a href=\'index.cgi?fun=listalias&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=created&orderby='.$cord.'&susername='.$in{'susername'}.'\'>Created on</a>';
$mod_url='<a href=\'index.cgi?fun=listalias&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=modified&orderby='.$mord.'&susername='.$in{'susername'}.'\'>Modified on</a>';
$act_url='<a href=\'index.cgi?fun=listalias&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=active&orderby='.$mord.'&susername='.$in{'susername'}.'\'>Active</a>';
$goto_url='<a href=\'index.cgi?fun=listalias&vpopmaildomain='.$in{'vpopmaildomain'}.'&colname=goto&orderby='.$gord.'&susername='.$in{'susername'}.'\'>Go To</a>';

print &ui_columns_start(['No.',$user_url,$goto_url,$create_url,$mod_url,$act_url]);


####$sqlin="SELECT a.`username`, a.`password`, a.`name`, a.`maildir`, a.`quota`, a.`domain`, a.`created`, a.`modified`, a.`active`,b.`autoclean_trash`, b.`autoclean_spam`, b.`autoclean_promo`, b.`change_pass_max_days`, b.`change_pass_alerts_before_days`, b.`lastlogintime`, b.`lastloginip`  FROM `mailbox`  as a LEFT JOIN `powermailbox` as b ON a.`username` = b.`username`  where  a.`domain` = '".$vdomain."' ".$ssql." order by ".$colname." ".$orderby."  ";

$sqlin="SELECT `address`, `goto`, `domain`, `created`, `modified`, `active`  FROM `alias` as a  WHERE `domain` = '".$vdomain."' and `address`  NOT IN ( SELECT `username` FROM `mailbox` WHERE `domain` = '".$vdomain."' ) ".$ssql." order by ".$colname." ".$orderby." ";

#print " -- $sqlin";

$table_data = $dbh->prepare($sqlin);
$table_data->execute;
$vno=0;
while(($guser,$goto,$gdom,$gcreate,$gmod,$gact)=$table_data->fetchrow_array)
{
$vno++;
$gact2="NO";
if($gact == 1){$gact2="YES";}
$guser2=$guser;
$guser2="<a href=\"index.cgi?vpopmaildomain=".$in{'vpopmaildomain'}."&fun=editalias&vusername=".$guser."&\">".$guser."</a>";
$ctime=$gcreate;

##$goto=~ s/,/",<br>"/eg;
if($show_goto_address==0)
{
@zaqlist=();@zaqlist=split/,/,$goto;$gotox=0;
$goto = @zaqlist;
}

if($show_goto_address==1)
{
$goto=~ s/,/",<br>"/eg;
}



$mtime=$gmod;
print &ui_columns_row([$vno,$guser2,$goto,$ctime,$mtime,$gact2]);
}
print &ui_columns_end();

print ui_table_end();


}

### View alias List --end



print "</center>";
}
#### valid domain --end
print "</form>";
ui_print_footer();


