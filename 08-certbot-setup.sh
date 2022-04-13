#!/bin/sh

/etc/init.d/apache2 stop
certbot certonly -d `hostname -f` --standalone --agree-tos --email postmaster@`hostname -f`



## fore using dns challenge for local setup. 
## it woyuld give you TXT record info to create and than press enter to verify.

##certbot certonly -d `hostname -f`  --agree-tos --email postmaster@`hostname -f` --manual --preferred-challenges=dns --register

/etc/init.d/apache2 start
