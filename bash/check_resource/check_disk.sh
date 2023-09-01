#!/bin/bash
################ MONITOREO DE ESPACIOS MAYORES A 85% ################
YEL='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
cd /tmp
HOST=`hostname`
IP=`/sbin/ifconfig | grep -oiE '([0-9]{1,3}\.){3}[0-9]{1,3}' | egrep -v "255|127.0.0.1" | awk 'NR==1'`
TMP=fs_critico.lst
TMP1=fs_warning.tmp
TMP2=fs_critico.tmp
TMPTOTAL=fs_total.lst
cat /dev/null > fs_critico.lst
cat /dev/null > fs_critico.tmp
cat /dev/null > fs_warning.tmp
cat /dev/null > fs_total.lst

function xSizeDisk(){
df -Ph | grep -i '%'| grep -vE 'boot|shm|media|mnt' > $TMP
cat $TMP | awk '{print $6 " en " $5}' > $TMP2
cat $TMP2 | grep -iE '85%|86%|87%|88%|89%|90%|91%|92%|93%|94%' > $TMP1
cat $TMP2 | grep -iE '95%|96%|97%|98%|99%|100%' > $TMP
}

function xFindSizedisk(){
    xRuta=$1
    if [ $xRuta != '/' ];
    then
	  du -hs $xRuta/*  2>/dev/null | sort -hr | head > fs_total.lst
    else
	  du -hs /*  2>/dev/null | sort -hr | head > fs_total.lst
    fi
}

function xShowSizingDisk(){
xSizeDisk
if [ -s $TMP1 ];
then
    echo -e "$YEL!! Warning !!$NC"
    echo "Los volumenes con mayor sizing son: "
    cat $TMP1
    echo "Los subdirectorios que tienen mayor sizing son:"
    for i in `cat $TMP1|awk '{print $1}'`;
    do
           echo "################################"
           echo "Directorio Padre $i"
           xFindSizedisk $i
           cat fs_total.lst
    done
fi
if [ -s $TMP ];
then
    echo -e "$RED!! Cristical !!$NC"
    echo "Los volumenes con mayor sizing son: "
    cat $TMP
    echo "Los subdirectorios que tienen mayor sizing son:"
        for i in `cat $TMP|awk '{print $1}'`;
        do
           echo "################################"
           echo "Directorio Padre $i"
           xFindSizedisk $i
           cat fs_total.lst
        done
else
        echo "No hay Filesystems con tamano mayor al 85%"
fi
}
xShowSizingDisk