#!/bin/bash




## installs 
apt-get -y install mariadb-server php apache2 libapache2-mod-php php-mysql php-cli php-common php-imap php-ldap php-xml php-curl php-mbstring php-zip php-apcu php-gd php-imagick imagemagick mcrypt memcached php-memcached php-bcmath dbconfig-common libapache2-mod-php php-intl php-mysql php-intl libdbd-mysql-perl certbot python3-certbot-apache automysqlbackup php-mailparse 
## to use more advance database storage type
# apt-get install mariadb-plugin-rocksdb

a2enmod actions > /dev/null 2>&1
a2enmod proxy_fcgi > /dev/null 2>&1
a2enmod fcgid > /dev/null 2>&1
a2enmod alias > /dev/null 2>&1
a2enmod suexec > /dev/null 2>&1
a2enmod rewrite > /dev/null 2>&1
a2enmod ssl > /dev/null 2>&1
a2enmod actions > /dev/null 2>&1
a2enmod include > /dev/null 2>&1
a2enmod dav_fs > /dev/null 2>&1
a2enmod dav > /dev/null 2>&1
a2enmod auth_digest > /dev/null 2>&1
a2enmod cgi > /dev/null 2>&1
a2enmod headers > /dev/null 2>&1
a2enmod proxy_http > /dev/null 2>&1

## keep fpm disabled default if installed by mistake
systemctl stop php.fpm  > /dev/null 2>&1
systemctl disable php-fpm > /dev/null 2>&1



MYSQLPASSVPOP=`pwgen -c -1 8`
echo $MYSQLPASSVPOP > /usr/local/src/mariadb-mydbadmin-pass
echo "mydbadmin password in /usr/local/src/mairadb-mydbadmin-pass"

echo "GRANT ALL PRIVILEGES ON *.* TO mydbadmin@localhost IDENTIFIED BY '$MYSQLPASSVPOP'" with grant option | mysql -uroot
mysqladmin -uroot reload
mysqladmin -uroot refresh

files/extra-files/etc-config-backup.sh
##If need all rsyslog in MySQL DB
##apt-get -y install rsyslog-mysql

## copy apache2 and other config html files cron and rsyslog 
/bin/cp -pR files/web-rootdir/* /

## SysLog and MailLog to put in Database for report


### changing timezone to Asia Kolkata
sed -i "s/;date.timezone =/date\.timezone \= \'Asia\/Kolkata\'/" /etc/php/7.4/apache2/php.ini
sed -i "s/;date.timezone =/date\.timezone \= \'Asia\/Kolkata\'/" /etc/php/7.4/cli/php.ini
##disable error
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ERROR/" /etc/php/7.4/cli/php.ini
sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ERROR/" /etc/php/7.4/apache2/php.ini


systemctl restart  apache2
systemctl restart  rsyslog
systemctl restart  cron
systemctl restart  mariadb




