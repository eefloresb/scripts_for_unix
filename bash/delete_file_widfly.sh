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

# Script que permite borrar los los logs generados por widfly soportado para Linux y Solaris
OS=$(uname)
FECHA=$(date +%Y-%m-%d)
if [ $OS = "Linux" ]; then {  
  
  # delete file to greater than 1G and rotate every 30 days
  _xClean_log_console(){
    xRUTA=$1
    if [[ -f "$xRUTA/console.log" ]]; then
      cd $xRUTA
      declare -i myfilesize=$(stat --format=%s "console.log")
      if (( $myfilesize/1024/1024/1024 > 0 )); then
           echo "compress and delete log when size is major to 1G - $FECHA" >> /var/log/log_rotate_wildfly.log
           gzip -c console.log > console.log_$FECHA.gz 
           cat /dev/null > console.log
      fi
      if ls console_*.log >/dev/null; then
        IFS=$'\n'
        for i in $(ls console_*.log); do 
          gzip $i
        done
      fi
      if $(ls "*.gz"); then 
        find . -name "console.log_*" -type f -mtime +30 -exec rm -rfv {} \; >> /var/log/log_rotate_wildfly.log
      fi
    fi
  }
  
  _xComprime_directorios(){
      xRUTA=$1
      if [ -d $xRUTA ]; then
          cd $xRUTA
          find . -type f -mtime +0 | grep server.log.202[0-9]-[0-9][0-9]-[0-9][0-9]$ | while read line; do gzip $line; done
      fi
  }
  
  _xDelete_directorios_cada_90_dias(){
      xRUTA=$1
      if [ -d $xRUTA ]; then
          cd $xRUTA
          echo "file Server.log.gz-20*.gz delete for 30 days - $FECHA" >> /var/log/log_rotate_wildfly.log
          find . -name "server.log.20*.gz" -type f -mtime +30 -exec rm -rfv {} \; >> /var/log/log_rotate_wildfly.log
      fi
  }
  
  RUTA="/opt/wildfly/standalone/log/:/var/log/wildfly"
    IFS=":"
    
    for dir in $RUTA; do
        _xClean_log_console $dir
        _xComprime_directorios $dir
        _xDelete_directorios_cada_90_dias $dir
    done
  }
  elif [ $OS = "SunOS" ]; then {

    _xComprime_directorios(){
        xRUTA=$1
        if [ -d $xRUTA ]; then
            cd $xRUTA
            find . -name "*.log" -mtime +0 | while read line;do gzip $line; done
        fi
    }

    _xDelete_directorios_cada_90_dias(){
        xRUTA=$1
        if [ -d $xRUTA ]; then
            cd $xRUTA
            echo "the files logs from wildfly delete every 32 days - $FECHA" >> /var/adm/log/log_rotate_wildfly.log
            find . -name "*.log.gz" -type f -mtime +32 -exec rm -rfv {} \; >> /var/adm/log/log_rotate_wildfly.log
        fi
    }

  RUTA="/six/sixtcl/Wildfly/wildfly-13.0.0.Final/standalone-bo/log:/six/sixtcl/Wildfly/novalog/SIXMON"
    IFS=":"

    for dir in $RUTA; do
        _xComprime_directorios $dir
        _xDelete_directorios_cada_90_dias $dir
    done
 }
fi
