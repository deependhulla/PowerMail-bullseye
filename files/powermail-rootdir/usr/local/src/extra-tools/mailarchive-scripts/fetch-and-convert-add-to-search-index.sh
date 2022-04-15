#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR

if [ -f '/tmp/read-work-on-fetch-archive.pid' ];
then
   echo "File /tmp/read-work-on-fetch-archive.pid exists"
else

touch /tmp/read-work-on-fetch-archive.pid
mkdir /archive-data 2>/dev/null
mkdir /archive-data/mail-archive-compress 2>/dev/null
mkdir /archive-data/fetched-data 2>/dev/null
mkdir /archive-data/fetch-process 2>/dev/null
## rsync from other server without convert
rsync -av rbackup@192.192.10.22::archivedata/mail-archive-uncompress* /archive-data/fetched-data/  --remove-source-files --password-file=/usr/local/src/mailarchive-scripts/rpass

perl convert-postfix-mails-to-eml-for-archive-stage2.pl 

cd /usr/local/src/mailarchive-scripts
## clean empty file
find /archive-data/fetch-process/ -type f -empty -delete

find /archive-data/fetch-process/ -type f -exec php read-mail-and-move-to-date-folder.php {} \;
cd -

echo done.
/bin/rm -rf /tmp/read-work-on-fetch-archive.pid
fi



