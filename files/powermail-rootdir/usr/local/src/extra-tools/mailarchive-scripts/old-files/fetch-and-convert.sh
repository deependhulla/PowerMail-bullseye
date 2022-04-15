#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ -f '/tmp/read-work-on-fetch-archive.pid' ];
then
   echo "File /tmp/read-work-on-fetch-archive.pid exists"
else

touch /tmp/read-work-on-fetch-archive.pid
mkdir /archivedata/mail-fetched 2>/dev/null
mkdir /archivedata/mail-archive-process/ 2>/dev/null
## rsync from other server without convert
##rsync -av rbackup@192.168.16.244::emailarchive/* /archive-mail-data/stage2/online/  --remove-source-files --password-file=/usr/local/src/mailarchive-scripts/rpass
rsync -av rbackup@192.192.10.22::mailarchive/* /archivedata/mail-fetched/ --remove-source-files --password-file=/usr/local/src/mailarchive-scripts/rpass


## for mailscanner with postfix
/usr/local/src/mailarchive-scripts/convert-postfix-mails-to-eml-for-archive-stage2.pl

echo done.
/bin/rm -rf /tmp/read-work-on-fetch-archive.pid
fi



