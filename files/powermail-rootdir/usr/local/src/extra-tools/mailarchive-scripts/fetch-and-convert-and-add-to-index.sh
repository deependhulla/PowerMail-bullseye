#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RECOLL_TMPDIR=/archivedata/index-temp-folder/


if [ -f '/tmp/read-work-on-fetch-archive.pid' ];
then
   echo "File /tmp/read-work-on-fetch-archive.pid exists"
else

find /archivedata/mail-fetched/* -type d -empty -delete -print

touch /tmp/read-work-on-fetch-archive.pid
mkdir /archivedata/mail-fetched 2>/dev/null
mkdir /archivedata/mail-archive-process/ 2>/dev/null
mkdir /archivedata/index-temp-folder 2>/dev/null

rsync -av rbackup@192.192.10.22::mailarchive/* /archivedata/mail-fetched/ --remove-source-files --password-file=/usr/local/src/mailarchive-scripts/rpass

## for mailscanner with postfix
/usr/local/src/mailarchive-scripts/convert-postfix-mails-to-eml-for-archive-stage2.pl

find /archivedata/mail-archive-process/ -type f -exec php read-mail-and-move-to-date-folder.php {} \;

echo done.
/bin/rm -rf /tmp/read-work-on-fetch-archive.pid
fi



