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

# Elimina y comprime logs de Azure, la eliminación ocurre pasado los 30 días 
# y la compresión depende de la configuración realizada a nivel de cron

__azure_log(){
  DIR="/var/log/azure"
  if [[ -d $DIR]]; then 
  cd $DIR 
  ls -C1d * | while read line; do 
      cd $line
      ls -C1dt * | tail -n +2 | while read dir; do 
          find . -exec gzip {} \;
      done 
      cd ..
  done
  fi
} 

__modules(){
  DIR="/var/log/nginx"
  if [[ -d $DIR]]; then 
      cd $DIR 
      find . -mtime +30 -exec rm -rfv {} \;
  fi
}

DIR="/root/IZIPAY_LOG"
if [[ -d $DIR ]]; then 
  cd $DIR 
  find . -size +2M | grep -vE "*.gz" | while read line; do 
  gzip $line
done
fi
