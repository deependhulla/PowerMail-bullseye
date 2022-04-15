#!/bin/sh

#echo >  /var/log/dovecot.log

ALERT=80
df -H |  grep -vE '^Filesystem|tmpfs|udev|cdrom|none' | awk '{ print $5 " " $6 " " $1 }' | while read output;
do
  echo $output
  a=`df -H | grep -vE '^Filesystem|tmpfs|udev|cdrom|none'`
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $ALERT ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname -f) as on $(date)" |
  
sendEmail -f postmaster@`hostname -f` -t postmaster@`hostname -f`  -u "$(hostname -f) Alert: $partition out of disk space $usep%" -m "Dear Admin \n \n Following Partition Running out of space \"$partition ($usep%)\" on $(hostname -f) as on $(date) please take necessary action   \n \n $a  \n \n -AutoAdmin" -o tls=no -s 127.0.0.1:25 
  fi
done

