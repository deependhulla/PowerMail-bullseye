
cat  /var/log/dovecot.log | grep "unknown user (given password" | cut -d "," -f 2 |  cut -d ")" -f 1  | sort | uniq  > /root/ip-for-unknown-user


php get-all-ip-to-contry-list.php /root/ip-for-unknown-user 

php -n get-all-ip-to-contry-list.php /root/ip-for-unknown-user    | cut -d "," -f 3 | sort| uniq > uniq-country
cat  /var/log/dovecot.log | grep "unknown user (given password" | cut -d "," -f 2 |  cut -d ")" -f 1  | sort | uniq -c | sort | tail      
cat  /var/log/dovecot.log | grep "unknown user (given password" | cut -d "," -f 2 |  cut -d ")" -f 1  | sort | uniq -c | sort | tail | sed 's/  / /g'  | sed 's/  / /g'  |sed 's/  / /g'  | sed 's/  / /g'  | cut -d " " -f 3 > /tmp/read-ip
php get-all-ip-to-contry-list.php /tmp/read-ip

