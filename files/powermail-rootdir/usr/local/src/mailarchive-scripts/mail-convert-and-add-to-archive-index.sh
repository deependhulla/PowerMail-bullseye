#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR

#export LANGUAGE=en_US.UTF-8
#export LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
export RECOLL_TMPDIR=/home/archivedata/index-temp-folder/


if [ -f '/tmp/read-work-on-fetch-archive.pid' ];
then
   echo "File /tmp/read-work-on-fetch-archive.pid exists"
else
touch /tmp/read-work-on-fetch-archive.pid

mkdir /home/archivedata/mail-archive-process/ 2>/dev/null
mkdir /home/archivedata/index-temp-folder 2>/dev/null
find /home/archivedata/mail-archive-uncompress/* -type d -empty -delete -print 
clear
mkdir /home/archivedata/mail-archive-uncompress/ 2>/dev/null
chmod 777 /home/archivedata/mail-archive-uncompress/ 
## for mailscanner with postfix
/usr/local/src/mailarchive-scripts/convert-postfix-mails-to-eml-for-archive-stage2.pl

find /home/archivedata/mail-archive-process/ -type f -exec php read-mail-and-move-to-date-folder.php {} \;

echo done.
/bin/rm -rf /tmp/read-work-on-fetch-archive.pid
fi



