#!/bin/sh
clear
echo Free Cache and Memory , once a day. 
w
free
date
sync; echo 3 > /proc/sys/vm/drop_caches
date
swapoff -a
date
swapon -a
date
free
echo "All Done";
echo "";

