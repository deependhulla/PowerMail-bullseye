#!/bin/sh

## install postfix dovecot fetchmail and recoll for search-engine for archive use latter
apt-get -y install postfix-mysql dovecot-mysql dovecot-sieve dovecot-managesieved dovecot-imapd dovecot-pop3d dovecot-sieve dovecot-antispam sendemail  dovecot-fts-xapian postfix-pcre postfwd whois opendkim opendkim-tools xapian-tools recoll libdatetime-format-mail-perl fetchmail imapproxy

echo `hostname -f` > /etc/mailname
## adding 89 so that migration from qmailtoaster setup is easier.
groupadd -g 89 vmail 2>/dev/null
useradd -g vmail -u 89 -d /home/powermail vmail 2>/dev/null
## take one etc backup for safety
files/extra-files/etc-config-backup.sh

touch /var/log/dovecot.log
chmod 666 /var/log/dovecot.log


sed -i "s/SOCKET\=local\:\$RUNDIR\/opendkim.sock/#SOCKET\=local\:\$RUNDIR\/opendkim.sock/" /etc/default/opendkim
sed -i "s/#SOCKET\=inet\:12345\@localhost/SOCKET\=inet\:12345\@localhost/" /etc/default/opendkim
/lib/opendkim/opendkim.service.generate
systemctl daemon-reload

MYSQLPASSVPOP=`pwgen -c -1 8`
echo $MYSQLPASSVPOP > /usr/local/src/mysql-powermail-pass
mysqladmin create powermail -uroot 1>/dev/null 2>/dev/null
echo "GRANT ALL PRIVILEGES ON powermail.* TO powermail@localhost IDENTIFIED BY '$MYSQLPASSVPOP'" | mysql -uroot
mysqladmin -uroot reload
mysqladmin -uroot refresh

## copy apache2 and other config html files 
/bin/cp -pR files/powermail-rootdir/* / 2>/dev/null
/bin/cp -pR files/powermail-rootdir/bin/* /bin/

chown -R vmail:vmail /home/powermail
systemctl restart rsyslog
# dowload latest for checking ip when attack for country to check
/usr/local/src/ip-to-location/download-latest-ip-db.sh 2>/dev/null

## remove different mail log files and reset one used
echo > /var/log/mail.log
/bin/rm -rf /var/log/mail.info
/bin/rm -rf /var/log/mail.warn
/bin/rm -rf /var/log/mail.err


mysql < files/powermaildb.sql
mysql < files/powermail-extra-features.sql


sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_relay_domains_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_virtual_alias_domain_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_virtual_alias_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_virtual_domains_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_virtual_mailbox_limit_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/postfix/sql/mysql_virtual_mailbox_maps.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/dovecot/dovecot-dict-sql.conf.ext
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /etc/dovecot/dovecot-lastlogin-map.ext
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /etc/postfix/main.cf
sed -i "s/ohm8ahC2/`cat /usr/local/src/mysql-powermail-pass`/" /home/powermail/etc/powermail.mysql
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /etc/apache2/sites-available/default-ssl.conf

## use only for heavy load server 
systemctl stop imapproxy.service 2>/dev/null
systemctl disable imapproxy.service 2>/dev/null

chown -R www-data:www-data /var/www/html


echo "manager:xxxxxjpihs:0" >> /etc/webmin/miniserv.users
echo "manager:powermail postfix custom" >>  /etc/webmin/webmin.acl

cd /usr/share/webmin
WEPASSVPOP=`pwgen -c -1 8`
echo $WEPASSVPOP > /usr/local/src/manager-powermail-pass
/usr/share/webmin/changepass.pl  /etc/webmin manager `cat /usr/local/src/manager-powermail-pass`
cd -

##disable this program as not needed
systemctl disable ModemManager
systemctl disable wpa_supplicant

/etc/init.d/opendkim stop
/etc/init.d/opendkim start

/home/powermail/bin/vadddomain `hostname -f`
/home/powermail/bin/vaddalias root@`hostname -f` postmaster@`hostname -f`
/home/powermail/bin/vaddalias clamav@`hostname -f` postmaster@`hostname -f`
/home/powermail/bin/vaddalias abuse@`hostname -f` postmaster@`hostname -f`
/home/powermail/bin/vaddalias fbl@`hostname -f` postmaster@`hostname -f`
/home/powermail/bin/vaddalias www-data@`hostname -f` postmaster@`hostname -f`

#/home/powermail/bin/vaddalias root@`hostname -d` postmaster@`hostname -d`
#/home/powermail/bin/vaddalias clamav@`hostname -d` postmaster@`hostname -d`
#/home/powermail/bin/vaddalias abuse@`hostname -d` postmaster@`hostname -d`
#/home/powermail/bin/vaddalias fbl@`hostname -d` postmaster@`hostname -d`


:
