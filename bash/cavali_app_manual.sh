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

# Desarrollado para el cliente Cavali en el cual se requiere que tenga un script de inicio y fin de sus aplicaciones
__usage()
{
    if [ -n "$1" ] ; then
        echo "$1" >&2
        echo ""
    fi
cat << EOT >&2
  echo "REST – 8843"
  Usage: ./$0 -r
  echo "SOAP – 8090"
  Usage: ./$0 -s 
  echo "DESMATERIALIZACION – 8844"
  Usage: ./$0 -d 
  echo "MIGRATION – 9090"
  echo "./$0 -m"
  echo "ALL Services REST – 8843 , SOAP – 8090, DESMATERIALIZACION – 8844, MIGRATION – 9090"
  echo "./$0 -a"
  echo " "
EOT
exit 1
}

__REST_8443() {
local RUTA="/app/digitall/apps/rest/"
  if [[ -d $RUTA ]]; then
    cd $RUTA 
    nohup java -jar digitall-rest-1.0.jar --spring.config.location=file:application.properties
  else
    echo "Route $RUTA not exist... call to jp of Cavali"
    exit 1
  fi
}

__SOAP_8090(){
  local RUTA="/app/digitall/apps/soap/"
   if [[ -d $RUTA ]]; then
     cd $RUTA 
     nohup java -jar digitall-soap-1.0.jar --spring.config.location=file:application.properties
   else
     echo "Route $RUTA not exist... call to jp of Cavali"
   fi
}

__DESM_8844(){
  local RUTA="/app/digitall/apps/desmaterialized/"
  if [[ -d $RUTA ]]; then 
    cd $RUTA
  else
    echo "Route $RUTA not exist... call to jp of Cavali"
  fi
}

__MIGR_9090(){
  local RUTA="/opt/digitall/apps/migra-fisicas-bbva/"
  if [[ -d $RUTA ]]; then
    cd $RUTA
    nohup java -jar comeletras-migration-bbva-0.0.1.jar --spring.config.location=file:application.properties
  else
    echo "Route $RUTA not exist... call to jp of Cavali"
  fi
}

__all_services(){
__DESM_8844
sleep 3
__MIGR_9090
sleep 3
__REST_8443
sleep 3
__SOAP_8090
}


while getopts "a:d:r:m:s:" OPTS; do 
  case "$OPTS" in
      -s)
        __SOAP_8090;;
      -r) 
        __REST_8443;;
      -m) 
        __MIGR_9090;;
      -d)
        __DESM_8844;;
      -a)
        __all_services;;
       *) 
        __usage ;;
  esac  
done 

if [ -z "$1" ]; then
    echo "you must enter at least one parameter"
    echo "$0 -s ==> start __SOAP_8090"
    echo "$0 -r ==> start __REST_8443"  
    echo "$0 -m ==> start __MIGR_9090"
    echo "$0 -d ==> start __DESM_8844"
    echo "$0 -a ==> all services"
    exit 1
fi
