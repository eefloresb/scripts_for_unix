#!/bin/bash
IPADDRESS=`ip addr show |grep -E inet[[:blank:]]+.*|grep -v 127.0.0.1 | awk -F "[V ]+" '{print $3}' | head -1 | awk -F "/" '{print $1}'`
HOSTNAME=`hostname -f`
echo hostname,ipaddress,package name,installed version,repository
yum list installed 2>&1|grep -E ".*\.(x86_64|ppcle|i386)[[:blank:]]+.*"|while read PNAME VERSION REPOSITORY
do
PNAME=${PNAME%.*}
VERSION=${VERSION%.*}
echo "$HOSTNAME,$IPADDRESS,$PNAME,$VERSION,$REPOSITORY"
done
