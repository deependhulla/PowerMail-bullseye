#!/bin/sh
cd /
echo "Remove old logs"
find /var/log/ -type f -name *.1 -exec rm -fv {} \;
find /var/log/ -type f -name *.2 -exec rm -fv {} \;
find /var/log/ -type f -name *.3 -exec rm -fv {} \;
find /var/log/ -type f -name *.4 -exec rm -fv {} \;
find /var/log/ -type f -name *.5 -exec rm -fv {} \;
find /var/log/ -type f -name *.6 -exec rm -fv {} \;
find /var/log/ -type f -name *.7 -exec rm -fv {} \;
find /var/log/ -type f -name *gz -exec rm -fv {} \;

