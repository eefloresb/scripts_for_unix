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
#Versión:1.0 
YEL='\033[0;33m'
RED='\033[0;31m'
GRE='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m' # No Color
app="digitall-rest"
LOG="/var/log/$app.log"
LOGERROR="/var/log/$app.error.log"
DATE=$(date +%y-%m-%d-%h:%m:%s)
RUTA="/app/digitall/apps/rest/:/home/centos/app/digitall/apps/rest/"

# Casos desarrollados:
# 1) función stop: 
#   a) si la app esta activa lo detiene caso contrario te informa que no esta activa.
#   b) si la app tiene más de un proceso PID, la función stop detiene todos los PID.
# 2) función start:
#   a) si la app esta corriendo en un PID no lo inicia y te informa.
#   b) si la app esta stop procede a iniciarlo validando si la carpetas existen.
# 3) funcion restart: 
#   a) stop and start 
# Manejo de Errores: 
# A) Si comando aprovisionado falla a la hora de ejecución, muestra error.
# B) Si a la hora de detener el proceso falla muestra error. 

__outputprg(){
appstop="$1"
 if [[ $appstop == "0" ]] ; then 
  echo -e "$GRE La aplicación $app fue detenida siendo el PID: $npid $NC"
 elif [[ $appstop == "1" ]]; then 
  echo -e "$RED WARNING: $YEL La aplicación no fue detenida correctamente o ya existia"
  echo -e "$RED WARNING: $YEL el proceso esta corriendo con pid $npid"
  echo -e "$RED ALERT: $YEL en caso quiera detenerla use: $NC $0 stop"
 elif [[ $appstop == "2" ]]; then 
  echo -e "$RED La aplicación no fue iniciada correctamente $NC"
 elif [[ $appstop == "3" ]]; then 
  echo -e "$RED WARNING: $YEL El Directorio $RUTA no existe $NC"
 elif [[ $appstop == "4" ]]; then 
  echo -e "$RED ERROR!!! $YEL !Comunicarse con el desarrollador o JP del proyecto Cavali! $NC"
 elif [[ $appstop == "5" ]]; then
  echo -e "$GRE La aplicación fue iniciada correctamente en el PID: $npid $NC"
 elif [[ $appstop == "6" ]]; then
  echo -e "$GRE Iniciando la aplicación $app $NC"
 else
  echo -e "$RED AVISO!!! $YEL La aplicación $app no esta activa $NC"
 fi
}

__return_pid(){
   npid=$(ps -fea | grep -Ei "$app" |grep -v grep|awk '{ print $2 }')
   echo $npid
 }

__STOP(){
  local npid=$(__return_pid)
  if [[ ! -z "$npid" ]]; then
    if [[ $(echo $npid | wc -w) > 1 ]]; then
       for i in $npid; do 
          kill $i
       done
       __outputprg $?
    else
      if kill $npid; then 
        __outputprg $? 
      fi
    fi
  else
    __outputprg
  fi
}

__START() {
IFS=":"
for RUTA in $RUTA; do
  if [[ -d $RUTA ]]; then
    cd $RUTA 
    npid=$(__return_pid)
    if [[ ! -z "$npid" ]]  ; then 
      __outputprg 1 
      exit 0 
    else  
      __outputprg 6 
      nohup java -jar digitall-rest-1.0.jar --spring.config.location=file:application.properties 1>>$LOG 2>$LOGERROR &
      if [[ $? == "1" ]]; then 
        cat $LOGERROR
        echo " "
        __outputprg 2 
        __outputprg 4 
        exit 0
      else
        npid=$(__return_pid)
        __outputprg 5
        exit 0
      fi
    fi 
  else
    continue
  fi
done
IFS=":"
for i in $RUTA; do
RUTA=$i
__outputprg 3
done
__outputprg 4
}

__HELP(){
    echo ""
    echo -e "$GRE Menu $app"
    echo -e ""
    echo -e "\t$BLU iniciar la $app, ejecutando el comando $NC: $0 start"  
    echo ""
    echo -e "\t$BLU detener la $app, ejecutando el comando $NC:   $0 stop"
    echo ""
    echo -e "\t$BLU detener e iniciar $app application$NC: $0 restart"  
    echo ""
    echo -e "\t$BLU Ver el menu de ayuda ejecute$NC: $0 -h"
    echo ""
  exit 0 
}

__RESTART(){
__STOP
sleep 1
__START
}


if [ -z "$1" ]; then
  __HELP
else
  case "$1" in
      start)
          __START;;
      stop)
          __STOP;;
      restart)  
          __RESTART;;
      -h) __HELP;;
       *)
          echo -e "$RED Ingrese valores permitidos\n"
          __HELP;;
  esac  
fi
