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

# Genera un reporte a nivel de la / que archivos están dentro de las carpetas bbva/bcp

while read line; do
BANK=$(echo $line | grep -Eiwo 'bbva|bcp')
if [[ -d $line ]]; then
 permisos=$(ls -ltrd $line|awk '{print $1}')
 user=$(ls -ltrd $line|awk '{print $3}')
 group=$(ls -lrd $line|awk '{print $4}')
 if [[ ! -z $BANK ]]; then 
    echo $BANK,$permisos,$user,$group,$line >> recolect_data.csv
 else
  echo SCOTIABANK,$permisos,$user,$group,$line >> recolect_data.csv
 fi
else
    value=$(echo "the directory $line not found")
    echo $BANK,$line,$value >> recolect_data.csv
fi
done < list_route_paths.txt 
