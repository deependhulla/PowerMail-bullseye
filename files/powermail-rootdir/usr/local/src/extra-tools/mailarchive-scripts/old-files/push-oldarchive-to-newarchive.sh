#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR

if [ -f '/tmp/read-work-on-archive.pid' ];
then
   echo "File /tmp/read-work-on-archive.pid exists"
else

touch /tmp/read-work-on-archive.pid




cd /usr/local/src/mailarchive-scripts
find /archivedata/oldarchivedata/mail-server-5-storage-archive/2012* -type f -exec php read-mail-and-move-to-date-folder-only-move.php {} \;
cd -

echo done.
/bin/rm -rf /tmp/read-work-on-archive.pid
fi



