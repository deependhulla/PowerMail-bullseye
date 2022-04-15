#!/bin/sh


/etc/init.d/apache2 stop
/usr/bin/certbot renew

cat /etc/letsencrypt/live/powermail.mydomainname.com/fullchain.pem > /etc/webmin/miniserv.pem 
cat /etc/letsencrypt/live/powermail.mydomainname.com/privkey.pem >> /etc/webmin/miniserv.pem 


/etc/init.d/apache2 start

/etc/init.d/dovecot restart
/etc/init.d/postfix restart
/etc/init.d/webmin restart
