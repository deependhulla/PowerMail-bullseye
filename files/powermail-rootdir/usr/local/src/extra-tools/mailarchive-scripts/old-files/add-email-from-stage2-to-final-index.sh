#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR

if [ -f '/tmp/read-work-on-archive.pid' ];
then
   echo "File /tmp/read-work-on-archive.pid exists"
else

touch /tmp/read-work-on-archive.pid




cd /usr/local/src/mailarchive-scripts
##find /mail-archive-process/ -type f -exec php read-mail-and-move-to-date-folder.php {} \;
find /archivedata/mail-archive-process/ -type f -exec php read-mail-and-move-to-date-folder.php {} \;
cd -

echo done.
/bin/rm -rf /tmp/read-work-on-archive.pid
fi



