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

# Script que te permite sacar reporte de los servidores remotos soporta 
# las distribuciones de 
##### Support to Ubuntu 18.04 20.04 22.04
##### Support to Debian 9 10 11
HOSTNAME=$(hostname -f)
IPADDRESS=`ip addr show |grep -E inet[[:blank:]]+.*|grep -v 127.0.0.1 | awk -F "[V ]+" '{print $3}' | head -1 | awk -F "/" '{print $1}'`
echo hostname,ipaddress,package name,current version,update version
apt list --upgradable 2>&1|sed -re "/(WARNING|Listing|Listando|^$)/d" | while read line;do
NAME=$(echo $line | awk -F "/" '{print $1}')
REPOSITORIO=$(echo $line | awk -F "/" '{print $2}'|awk -F " " '{print $1}'|awk -F "," '{print $1}')
UVERSION=$(echo $line|awk -F "[" '{print $2}'|awk -F ": " '{print $2}'|tr -d "]")
VERSION=$(echo $line|grep -oP '(?<= )[0-9:.a-z-]*(?= amd64)')
echo "$HOSTNAME,$IPADDRESS,$NAME,$VERSION,$UVERSION,$REPOSITORIO"
done
