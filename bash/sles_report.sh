#!/bin/bash
IPADDRESS=`ip addr show |grep -E inet[[:blank:]]+.*|grep -v 127.0.0.1 | awk -F "[V ]+" '{print $3}' | head -1 | awk -F "/" '{print $1}'`
HOSTNAME=`hostname`
RANDOMNAME=`date +%s | md5sum | awk '{ print $1 }' | tr '0123456789' '0lzeAsgtBa' | cut -c 1-12`
mkdir /tmp/$RANDOMNAME
echo "hostname,ipaddress,package name,current version,update version"
zypper lu | tail -n +6 | tr "|" "," | tr "+" ","|awk -F "[, ]+" '{print $3","$4","$5}' > /tmp/$RANDOMNAME.txt 
sed -i "s/^/$HOSTNAME,$IPADDRESS,/" /tmp/$RANDOMNAME.txt
cat /tmp/$RANDOMNAME.txt 
