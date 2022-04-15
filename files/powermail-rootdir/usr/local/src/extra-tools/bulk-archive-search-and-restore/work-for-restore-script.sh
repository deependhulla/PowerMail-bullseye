#!/bin/sh

echo "" > /tmp/tmp-restore-list.txt

php search-and-build-list.php $1 $2 >> /tmp/tmp-restore-list.txt
php uncompress-and-copy-mail-to-restore-location.php $1 $2
