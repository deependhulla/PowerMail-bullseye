#!/bin/sh

/home/powermail/bin/vdomaindetails-user-quota powermail.mydomainname.com MB   | sed 's/"//g' >  /tmp/tmp-domain.csv
echo "<html><body> Dear Admin, <br><br> Please find  MailBox Status as on `date`" > /tmp/tmp-domain.html
/usr/local/src/csv2html.awk /tmp/tmp-domain.csv >> /tmp/tmp-domain.html
sendEmail -f postmaster@powermail.mydomainname.com -t postmaster@powermail.mydomainname.com -u " Mail Disk Quota as on `date`"  -o message-file=/tmp/tmp-domain.html -s 127.0.0.1:25 -o tls=no -a /tmp/tmp-domain.csv

/bin/rm -f /tmp/tmp-domain.csv
/bin/rm -f /tmp/tmp-domain.html

