#!/bin/sh

BASEDIR=$(dirname $0)
echo $BASEDIR
cd $BASEDIR
if [ -f '/tmp/read-group-mail-list.pid' ];
then
   echo "File /tmp/read-group-mail-list.pid exists"
else

touch /tmp/read-group-mail-list.pid

#perl process-group-mail-list.pl
#perl process-group-mail-list-direct.pl
## all user mailbox...group --and direct copy mail-tomailbox for groupmail of internal domain.
process-group-mail-list-direct-with-extra-allusersetting.pl

/bin/rm -rf /tmp/read-group-mail-list.pid
fi


