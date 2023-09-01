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

# Script que te permite obtener de cada AIX el compilador y la versión solicitado por Marco Machado
# Funcionando en el pivot Linux de positiva
RUTAIPS="ip.txt"
COMMAND="lslpp -l | grep -i xlc"
FILETEMP="/tmp/filetemporal.txt"

echo Environment,Hostname, OS level, Tiene Compilador XL C/Cm, Version Compilador > reporte_aix.csv
for line in $(cat $RUTAIPS); do
      if [[  "$line" = "DEV" ]]; then
        echo "DEV" > /tmp/environment
	continue
      else
	if [[ "$line" = "QA" ]]; then
        	echo "QA" > /tmp/environment
		continue
	fi
      fi
      environment=$(cat /tmp/environment)
      ssh $line $COMMAND > $FILETEMP
      oslevel=$(ssh $line oslevel -s)
      hostname=$(ssh $line hostname -s )
      if [[ -s $FILETEMP ]]; then
        BAND="SI"
        VERSION=$(cat $FILETEMP | grep xlC.rte | awk -F " " '{print $2}')
            echo $environment,$hostname,$oslevel,$BAND,$VERSION >> reporte_aix.csv
      else
         echo $environment,$hostname,$oslevel,NO,NULL >> reporte_aix.csv
      fi
      echo "User,Comment" >  usuarios_$hostname.csv
      ssh $line cat /etc/passwd | awk -F ":" '{if($5 ~ " ") {print $1","$5} else {print $1",NO DEFINIDO"}}' >> usuarios_$hostname.csv
      rm -f $FILETEMP
done
