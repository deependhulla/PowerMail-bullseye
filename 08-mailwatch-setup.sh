#!/bin/sh

apt-get -y install spamassassin libgssapi-perl razor pyzor libencode-detect-perl libgeoip2-perl libnet-patricia-perl libbsd-resource-perl libencoding-fixlatin-perl libencoding-fixlatin-xs-perl liburi-encode-perl

wget https://github.com/MailScanner/v5/releases/download/5.3.4-3/MailScanner-5.3.4-3.noarch.deb -O /opt/MailScanner-5.3.4-3.noarch.deb
wget -c https://github.com/MailScanner/v5/releases/download/5.3.4-3/MailScanner-5.3.4-3.noarch.deb.sig -O /opt/MailScanner-5.3.4-3.noarch.deb.sig
sh files/extra-perl-modules.sh

dpkg -i /opt/MailScanner-5.3.4-3.noarch.deb
/usr/sbin/ms-configure --MTA=postfix --installClamav=N --installCPAN=Y --ignoreDeps=N --ramdiskSize=0

## allow http://lists.mailscanner.info/pipermail/mailscanner/2012-February/099106.html
## 
## Edit the AppArmor profile
## /etc/apparmor.d/usr.sbin.clamd
## Add these 2 lines:
##  /var/spool/MailScanner/** rw,
##  /var/spool/MailScanner/incoming/** rw,
## Then, reload AppArmor /etc/init.d/apparmor reload
## Else Error : clam  : lstat() failed on: /var/spool/MailScanner/incoming/
/bin/cp -pRv files/mailscanner-files/usr.sbin.clamd /etc/apparmor.d/
systemctl restart apparmor.service 2>/dev/null 

sed -i "s/run_mailscanner=0/run_mailscanner=1/" /etc/MailScanner/defaults 
/bin/cp -p files/mailscanner-files/header_checks /etc/postfix/header_checks

##/bin/cp -p files/mailscanner-files/clamd.conf /etc/clamav/

touch /etc/MailScanner/archives.filetype.rules.conf
touch /etc/MailScanner/archives.filename.rules.conf
touch /etc/MailScanner/filename.rules.conf
mkdir /var/spool/MailScanner/incoming 2>/dev/null
mkdir /var/spool/MailScanner/quarantine 2>/dev/null
mkdir /var/spool/MailScanner/incoming/Locks 2>/dev/null
chown postfix.postfix /var/spool/MailScanner/incoming
chown postfix.postfix /var/spool/MailScanner/quarantine
chown postfix:root /var/spool/postfix/

#/bin/cp -pRv files/mailscanner-files/ms-etc/* /etc/MailScanner/

## so that mailwatch can read
chmod 744 /var/spool/postfix/incoming/
chmod 744 /var/spool/postfix/hold/
chown -R postfix  /var/log/clamav 2>/dev/null
## Mail-Archive Tool
mkdir /archivedata
mkdir /archivedata/mail-archive-uncompress 2>/dev/null
mkdir /archivedata/mail-archive-compress 2>/dev/null
mkdir /archivedata/mail-archive-process 2>/dev/null
chmod 777 /archivedata
chmod 777 /archivedata/mail-archive-uncompress
chmod 777 /archivedata/mail-archive-compress
chmod 777 /archivedata/mail-archive-process

MYSQLPASSMAILW=`pwgen -c -1 8`
echo $MYSQLPASSMAILW > /usr/local/src/mysql-mailscanner-pass

echo "Creating Database mailscanner for storing all logs for mailwatch"
mysqladmin create mailscanner -uroot
mysql < files/mailscanner-files/MailWatch-1.2.17/create.sql 2>/dev/null
mysql < files/mailscanner-files/mailwatch-fix-for-subject-special-char-support.sql 2>/dev/null 
echo "GRANT ALL PRIVILEGES ON mailscanner.* TO mailscanner@localhost IDENTIFIED BY '$MYSQLPASSMAILW'" | mysql -uroot
mysqladmin -uroot reload
mysqladmin -uroot refresh

MYSQLPASSMW=`pwgen -c -1 8`
echo $MYSQLPASSMW > /usr/local/src/mailwatch-admin-pass

echo "adding user mailwatch with password for gui access , password in /usr/local/src/mailwatch-admin-pass";
echo "INSERT INTO \`mailscanner\`.\`users\` (\`username\`, \`password\`, \`fullname\`, \`type\`, \`quarantine_report\`, \`spamscore\`, \`highspamscore\`, \`noscan\`, \`quarantine_rcpt\`) VALUES ('mailwatch', MD5('$MYSQLPASSMW'), 'Mail Admin', 'A', '0', '0', '0', '0', NULL);"  | mysql;

touch /var/log/clamav/clamav.log 2>/dev/null
chmod 666 /var/log/clamav/clamav.log 2>/dev/null

/bin/cp -pR files/mailscanner-files/MailWatch-1.2.17/MailScanner_perl_scripts/*.pm /usr/share/MailScanner/perl/custom/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.17/tools/Cron_jobs/*.php /usr/local/bin/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.17/tools/Postfix_relay/*.php /usr/local/bin/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.17/tools/Postfix_relay/mailwatch-postfix-relay /usr/local/bin/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.17/tools/Cron_jobs/mailwatch /etc/cron.daily/
/bin/cp -pR files/mailscanner-files/MailWatch-1.2.17/mailscanner /var/www/html/
/bin/cp -pv files/mailscanner-files/conf.php /var/www/html/mailscanner/
chown -R www-data:www-data /var/www/html/mailscanner/
chmod 666 /var/spool/MailScanner/incoming/SpamAssassin.cache.db 1>/dev/null 2>/dev/null

sed -i "s/zaohm8ahC2/`cat /usr/local/src/mysql-mailscanner-pass`/" /var/www/html/mailscanner/conf.php
sed -i "s/zaohm8ahC2/`cat /usr/local/src/mysql-mailscanner-pass`/" /usr/share/MailScanner/perl/custom/MailWatchConf.pm
sed -i "s/powermail\.mydomainname\.com/`hostname`/" /var/www/html/mailscanner/conf.php
sed -i "s/powermail\.mydomainname\.com/`hostname`/"   /etc/MailScanner/MailScanner.conf

echo "Resarting all service ...please wait..."
systemctl restart mailscanner
systemctl restart dovecot
systemctl restart postfix
systemctl restart opendkim
systemctl restart clamav-daemon 2>/dev/null
systemctl restart cron

chmod 666 /var/spool/MailScanner/incoming/SpamAssassin.cache.db 2>/dev/null 1>/dev/null

echo "Done."
