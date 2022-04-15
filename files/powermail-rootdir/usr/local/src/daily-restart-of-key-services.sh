#!/bin/sh

/etc/init.d/apache2 restart
/etc/init.d/postfix restart
/etc/init.d/dovecot restart
/etc/init.d/spamassassin restart
/etc/init.d/clamav-daemon restart

