#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Edwin Enrique Flores Bautista
# Email: eflores@canvia.com

################ MONITOREO DE ESPACIOS MAYORES A 85% ################
# Genera un reporte a nivel del output de bash que me permite saber que filesystems ocupan mayor espacio al 85% 
# A su vez si se sobrepasa el valor de 85% se busca recursivamente el sizing de que subdirectorios ocupan mayor 
# espacio
YEL='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
cd /tmp
HOST=`hostname`
IP=`/sbin/ifconfig | grep -oiE '([0-9]{1,3}\.){3}[0-9]{1,3}' | egrep -v "255|127.0.0.1" | awk 'NR==1'`
TMP=/tmp/fs_critico.lst
TMP1=/tmp/fs_warning.tmp
TMP2=/tmp/fs_critico.tmp
TMP3=/tmp/fs_temporal.tmp
TMPTOTAL=fs_total.lst
cat /dev/null > fs_critico.lst
cat /dev/null > fs_critico.tmp
cat /dev/null > fs_warning.tmp
cat /dev/null > fs_total.lst
cat /dev/null > fs_temporal.tmp

function __check_df(){
    if [[ -s $TMP ]]; then
        echo "El fichero tiene de tamaño = 0, mandar evidencias
              a @canvia.com se sale del programa"
        exit 0
    else
        while read line; do 
            xperc=$(df $line|grep -Ev "(Filesystem|Used|Uso|Available|Disponible)" | awk '{print $5}')
            echo "$xperc,$line" >> $TMP3
        done < $TMP
        cat $TMP3 > $TMP
        cat $TMP | awk -F "," '{print $2 " en " $1}' > $TMP2
    fi
}

function __lsblk_disk(){
    #lsblk -f|grep -Eo "[[:digit:]]+%[[:blank:]]*(/[[:alpha:]]*)+" | tr " " "," | sort -t, -k2 | uniq > $TMP 
    declare -i xcol=$(lsblk -f|grep -Eo "[[:blank:]]+[[:digit:]]*%?[[:blank:]]*(/[[:alpha:]]*)+"|awk '{print NF}'|head -n1)
    if [[ -z $xcol ]]; then
        echo "No retorna columnas, revisar el comando lsblk,
              mandar evidencias a eflores@canvia.com se sale
              del programa"
        exit 0
    elif [[ $xcol == 1 ]]; then
        lsblk -f|grep -Eo "[[:blank:]]+[[:digit:]]*%?[[:blank:]]*(/[[:alpha:]]*)+" > $TMP
        __check_df 
    elif [[ $xcol == 2 ]]; then
        lsblk -f|grep -Eo "[[:digit:]]+%[[:blank:]]*(/[[:alpha:]]*)+" | tr " " "," | sort -t, -k2 | uniq > $TMP
        cat $TMP | awk -F "," '{print $2 " en " $1}' > $TMP2
    else
        echo "retorna columnas > 2, revisar el comando lsblk,
              mandar evidencias a eflores@canvia.com se sale
              del programa"
        exit 0
    fi
    if ! cat $TMP2 | grep -iE '85%|86%|87%|88%|89%|90%|91%|92%|93%|94%' > $TMP1; then 
        cat /dev/null > $TMP1
    fi
    if ! cat $TMP2 | grep -iE '95%|96%|97%|98%|99%|100%' > $TMP; then 
        cat /dev/null > $TMP
    fi
}

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
__lsblk_disk
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