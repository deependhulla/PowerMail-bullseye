#!/bin/sh

BASEDIR=$(dirname $0)
echo $BASEDIR
cd $BASEDIR
if [ -f '/tmp/read-push-to-other-mailserver.pid' ];
then
   echo "File /tmp/read-push-to-other-mailserver.pid exists"
else

touch /tmp/read-push-to-other-mailserver.pid

perl process-mail-to-push-to-other-mailserver-via-anonbranchmailbox.pl

/bin/rm -rf /tmp/read-push-to-other-mailserver.pid
fi


