<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Change Password </title>

<SCRIPT LANGUAGE="JavaScript">

function validatePwd(fieldname) {
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Copyright April 2004 Sani, A. I. (MCSE, MCSA, CCNA)
//sanijean@yahoo.co.uk
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//Initialise variables
var errorMsg = "";
var space  = " ";
oldpass = document.myForm.rashpswd.value;
fieldname   = document.myForm.newpswd;

fieldname_re = document.myForm.renewpswd.value;

fieldvalue  = fieldname.value;
fieldlength = fieldvalue.length;

fieldvalue_new = fieldvalue.toLowerCase();

uname = document.myForm.userid.value;

uname_new = uname.toLowerCase();

if(oldpass == fieldvalue){

errorMsg += "\nYou have Entered Old Password Again.\n";

}

//It must not contain a space

if (fieldvalue.indexOf(space) > -1) {
     errorMsg += "\nPasswords cannot include a space.\n";
}

//It must contain at least one number character
if (!(fieldvalue.match(/\d/))) {
     errorMsg += "\nStrong passwords must include one or more numbers.\n";
}
//It must start with at least one letter
if (!(fieldvalue.match(/^[a-zA-Z]+/))) {
    errorMsg += "\nStrong passwords must start with at least one letter.\n";
}
//It must contain at least one upper case character
if (!(fieldvalue.match(/[A-Z]/))) {
  errorMsg += "\nStrong passwords must include one uppercase letter.\n";
}
//It must contain at least one lower case character

var dvdx=0;
if (!(fieldvalue.match(/[a-z]/)) ) {
//     errorMsg += "\nStrong passwords must include one or more letters.\n";
//dvdx++;
}

if (!(fieldvalue.match(/[A-Z]/)) ) {
//errorMsg += "\nStrong passwords must include one or more letters.\n";
//dvdx++;
}

if(dvdx==0)
{
//errorMsg += "\nStrong passwords must include one or more letters.\n";

}
//It must contain at least one special character
if (!(fieldvalue.match(/\W+/))) {
     errorMsg += "\nStrong passwords must include special character - #,@,%,!\n";
}
//It must be at least 8 characters long.
if (!(fieldlength >= 8)) {
     errorMsg += "\nStrong passwords must be at least 8 characters long.\n";
}


if(!(fieldvalue==fieldname_re)){

    errorMsg += "\nNew Password And Confirm Password Did not match.\n";
}


newu = uname_new.split(/[^a-zA-Z]/);

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

errorMsg += "\nNew Password Should not Contain Any Word From E-Mail Address\n";

}





//If there is aproblem with the form then display an error
     if (errorMsg != ""){
          msg = "______________________________________________________\n\n";
//          msg += "Please correct the problem(s) with your new password .\n";
  //        msg += "______________________________________________________\n";
          errorMsg += alert(msg + errorMsg + "\n\n");
          fieldname.focus();
          return false;
     }

     return true;
}

</script>

</head>

                                                                               
<body>
<form name="myForm" method="post" action="changepass.php" onSubmit="return validatePwd('newpswd');">



<table align="center" border="0" cellpadding="0" cellspacing="0" width="80%">
 
<tbody><tr bgcolor="#f1f1f1"><td colspan="2" align="center"><font face="Verdana" size="3"><b>Change Email Password</b></font><br>&nbsp;</td></tr>
<tr  bgcolor="#f1f1f1"><td>&nbsp;<font face="Verdana" size="2">Email Address<strong>&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp(e.g.username@yourdomain.com)</strong></font></td><td><font face="Verdana" size="2"><input name="userid" type="text" size=40></font></td></tr>
<tr bgcolor="#f1f1f1"><td>&nbsp;<font face="Verdana" size="2">Old Password</font></td><td><font face="Verdana" size="2"><input name="rashpswd" type="password" size=40 ></font></td></tr>
<tr bgcolor="#cccccc"><td colspan="2" align="left"><font face="Verdana" size="2">
&nbsp;Enter new 8 or more character password having AlphaNumeric and <br>&nbsp;Special Character combination to have Strong Password.</font>
</td></tr>

<tr bgcolor="#f1f1f1"><td>&nbsp;<font face="Verdana" size="2">Enter New Strong Password<strong>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp( e.g. Myp@ss5d )</strong></font></td><td><font face="Verdana" size="2"><input name="newpswd" type="password" size=40 maxlength=16></font></td></tr>

<tr bgcolor="#f1f1f1"><td>&nbsp;<font face="Verdana" size="2">Re-enter New Strong Password<strong>&nbsp&nbsp(same as  new password i.e. Myp@ss5d)</strong></font></td><td><font face="Verdana" size="2"><input name="renewpswd" type="password" size=40></font></td></tr>


<tr bgcolor="#f1f1f1"><td colspan="2" align="center"><br><input name="pswd"  value="Change Password" type="submit">
<br>&nbsp;
</td></tr>
</tbody></table>
</form>
<?
//print $_SERVER['REMOTE_ADDR'];
?>





</body></html>
