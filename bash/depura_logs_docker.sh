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

# Depura los logs almacenados en docker, los cuales son generados por la aplicación
RUTA="/var/lib/docker/containers/"
FECHA=$(date +%Y-%m-%d)
cd $RUTA
for i in $(ls -C1d *); do
  if [[ -d $i ]]; then
    cd $i
    logfile=$(ls -C1d *.log)
    if [[ -f $logfile ]]; then
    	declare -i myfilesize=$(stat --format=%s "$logfile")
      	if (( $myfilesize/1024/1024/1024 > 0 )); then
           echo "compress $logfile when size is major to 999M - $FECHA" >> /var/log/logrotate_docker.log
           cat /dev/null > $logfile
      	fi
    fi
    cd ..
  fi
done
