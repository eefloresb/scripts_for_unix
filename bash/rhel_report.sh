#!/bin/bash
# Autor: Edwin Flores Bautista
# Mail: eflores@canvia.com 
# License: glpv2
IPADDRESS=`ip addr show |grep -E inet[[:blank:]]+.*|grep -v 127.0.0.1 | awk -F "[V ]+" '{print $3}' | head -1 | awk -F "/" '{print $1}'`
HOSTNAME=`hostname -f`
echo hostname,ipaddress,package name,current version,update version,repository
yum list updates 2>&1|grep -E ".*\.(x86_64|ppcle|i386)[[:blank:]]+.*"|while read PNAME UVERSION REPOSITORY
do
PNAME=${PNAME%.*}
machine=$(uname -m)
#VERSION=$(rpm -q $PNAME | grep -woE "(([[:digit:]][[:alpha:]]*+(\.|-)?)+[[:digit:]]+)" ) => remove test
#VERSION=$(rpm -q $PNAME | grep $machine | tail -1 | grep -woE "(([[:digit:]]+[[:alpha:]]*(\.|-)?)+[[:digit:]]+)")
VERSION=$(rpm -q $PNAME | grep $machine | tail -1)
VERSION=$(echo $VERSION |sed s/$PNAME\-//g)
VERSION=${VERSION%.$machine}
UVERSION=${UVERSION%.el*}
echo "$HOSTNAME,$IPADDRESS,${PNAME},${VERSION%.el*},${UVERSION},${REPOSITORY}"
done