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

# Script que te permite iniciar o detener un servicio para el cliente
YEL='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

__STOP_MIGR_9090(){
   nkill=$(ps -fea | grep -Ei "comeletras-migration-bbva" | grep -v grep)
   kill -s 9 $nkill
   echo "stoped ... $nkill REST process"
}


__START_MIGR_9090(){
  local RUTA="/opt/digitall/apps/migra-fisicas-bbva/"
  if [[ -d $RUTA ]]; then
    cd $RUTA
    nohup java -jar comeletras-migration-bbva-0.0.1.jar --spring.config.location=file:application.properties
  else
    echo "Route $RUTA not exist... call to jp of Cavali"
  fi
}

__HELP(){
    echo -e "$YEL The Menu $NC"
    echo -e "\t$RED start the comeletras-migration-bbva application$NC: ./$0 -s"  
    echo ""
    echo -e "\t$RED down the comeletras-migration-bbva application$NC:   ./$0 -d"
    echo ""
    echo -e "\t$RED stop and start comeletras-migration-bbva application$NC: ./$0 -r"  
    echo ""
    exit 0 
}

__RESTART_9090(){
__STOP_MIGR_9090
__START_MIGR_9090
}

while getopts "s:d:r" OPTS; do 
  case "$OPTS" in
      -s)
          __START_MIGR_9090;;
      -d)
          __STOP_MIGR_9090;;
      -r)  
          __RESTART_9090;;
      -h) __HELP;;
       *)
          echo "input allowed values $0"
          __HELP
  esac  
done 

if [ -z "$1" ]; then
  __HELP
fi

