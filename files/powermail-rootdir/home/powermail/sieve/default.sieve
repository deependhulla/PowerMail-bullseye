require ["date","fileinto","mailbox","relational","vacation"];
# rule:[Promotions]
if header :contains "X-Spam-Promotions" "YES"
{
	fileinto :create "Promotional";
	stop;
}
# rule:[Spam]
if header :contains "X-Spam-Flag" "YES"
{
	fileinto :create "Spam";
	stop;
}
# rule:[Out of office]
if allof (currentdate :value "ge" "date" "2016-12-28", currentdate :value "le" "date" "2016-12-31")
{
	vacation :days 4 :addresses "postmaster@powermail.mydomainname.com" "I am on vacation. Send email latter";
}
