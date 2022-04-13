#!/bin/sh

##/bin/cp files/rootdir/etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /etc/apache2/sites-available/default-ssl.conf
sed -i "s/SSLCertificateFile	\/etc\/ssl\/certs\/ssl-cert-snakeoil\.pem/ /" /etc/apache2/sites-available/default-ssl.conf
sed -i "s/SSLCertificateKeyFile \/etc\/ssl\/private\/ssl-cert-snakeoil\.key/ /" /etc/apache2/sites-available/default-ssl.conf
sed -i "s/#XSLCertificateFile/SSLCertificateFile/" /etc/apache2/sites-available/default-ssl.conf
sed -i "s/#XSLCertificateKeyFile/SSLCertificateKeyFile/" /etc/apache2/sites-available/default-ssl.conf
sed -i "s/#XSLCertificateChainFile/SSLCertificateChainFile/" /etc/apache2/sites-available/default-ssl.conf
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /etc/apache2/sites-available/000-default.conf
sed -i "s/#RewriteEngine/RewriteEngine/" /etc/apache2/sites-available/000-default.conf
sed -i "s/#RewriteCond/RewriteCond/" /etc/apache2/sites-available/000-default.conf
sed -i "s/#RewriteRule/RewriteRule/" /etc/apache2/sites-available/000-default.conf
ln -vs /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/
/etc/init.d/apache2 restart

sed -i "s/ssl_key = <\/etc\/ssl\/private\/ssl-cert-snakeoil\.key//" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/ssl_cert = <\/etc\/ssl\/certs\/ssl-cert-snakeoil\.pem//" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/#xssl_cert/ssl_cert/" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/#xssl_key/ssl_key/" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /etc/dovecot/conf.d/10-ssl.conf
/etc/init.d/dovecot restart

sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /etc/postfix/main.cf
sed -i "s/smtpd_tls_cert_file=\/etc\/ssl\/certs\/ssl-cert-snakeoil\.pem//" /etc/postfix/main.cf
sed -i "s/smtpd_tls_key_file=\/etc\/ssl\/private\/ssl-cert-snakeoil\.key//" /etc/postfix/main.cf
sed -i "s/smtp_tls_cert_file=\/etc\/ssl\/certs\/ssl-cert-snakeoil\.pem//" /etc/postfix/main.cf
sed -i "s/smtp_tls_key_file=\/etc\/ssl\/private\/ssl-cert-snakeoil\.key//" /etc/postfix/main.cf

sed -i "s/#xsmtpd_tls_cert_file/smtpd_tls_cert_file/" /etc/postfix/main.cf
sed -i "s/#xsmtpd_tls_key_file/smtpd_tls_key_file/" /etc/postfix/main.cf
sed -i "s/#xsmtp_tls_cert_file/smtp_tls_cert_file/" /etc/postfix/main.cf
sed -i "s/#xsmtp_tls_key_file/smtp_tls_key_file/" /etc/postfix/main.cf
/etc/init.d/postfix restart

cat /etc/letsencrypt/live/`hostname -f`/fullchain.pem > /etc/webmin/miniserv.pem
cat /etc/letsencrypt/live/`hostname -f`/privkey.pem >> /etc/webmin/miniserv.pem
/etc/init.d/webmin restart

#cp files/rootdir/usr/local/src/cert-renew-and-restart.sh /usr/local/src/
sed -i "s/powermail\.mydomainname\.com/`hostname -f`/" /usr/local/src/cert-renew-and-restart.sh

