#!/bin/sh


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
##saferside chown
chmod 666 /var/spool/MailScanner/incoming/SpamAssassin.cache.db 2>/dev/null 1>/dev/null

echo "Done."
