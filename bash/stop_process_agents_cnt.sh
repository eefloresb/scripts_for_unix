#!/bin/bash
app="java"
USER="ppldte"
LOG="/var/log/$app-access.log"
LOGERROR="/var/log/$app-error.log"
RUTA="/home/ppldte/command/"
RUTATMP="/home/ppldte/tmp/"

__outputprg(){
appstop="$1"
  if [[ $appstop == "0" ]]; then
     echo -e "La aplicación $app fue detenida correctamente"
  elif [[ $appstop == "1" ]]; then
     echo -e "La aplicación no esta activa"
  elif [[ $appstop == "2" ]]; then
     echo -e "La aplicación no fue iniciada correctamente"
  elif [[ $appstop == "3" ]]; then
     echo -e "$RED WARNING: $YEL El Directorio $RUTA no existe $NC"
  elif [[ $appstop == "4" ]]; then
     echo -e "ERROR!!!! Comunicarse con el desarrollador o JP del proyecto Centria!"
  elif [[ $appstop == "5" ]]; then
    echo -e "$GRE La aplicación fue iniciada correctamente en el PID: $npid $NC"   
  elif [[ $appstop == "6" ]]; then
     echo -e "Iniciando la aplicación $app"
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
    if [[ $(echo $npid | wc -w) >= 1 ]]; then
          killall -9 java
       if [[ -d $RUTATMP ]]; then
          cd $RUTATMP 
          for i in $(ls -C1 *.run); do 
            rm -rfv $i 
          done
       fi
       __outputprg $?
    else
       __outputprg 1
    fi
  else
    __outputprg
  fi
}

__START() {
for RUTA in $RUTA; do
  if [[ -d $RUTA ]]; then
    cd $RUTA
    bash ./setenv.sh 
    npid=$(__return_pid)
    if [[ ! -z "$npid" ]]  ; then
      __outputprg 1
      exit 0
    else
      __outputprg 6
      for program in web_start.sh agent_start.sh; do
          bash ./$program 1>>$LOG 2>>$LOGERROR &
          sleep 2 
          if [[ $(__return_pid) ]]; then 
            continue
          else
            __outputprg
          fi
      done
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
__outputprg 3
__outputprg 4
}


__RESTART(){
__STOP
sleep 1
__START
}

__HELP(){
    echo ""
    echo -e "Menu $app"
    echo -e ""
    echo -e "\t Iniciar la $app, ejecutando el comando : $0 start"
    echo ""
    echo -e "\t Detener la $app, ejecutando el comando :   $0 stop"
    echo ""
    echo -e "\t Detener e Iniciar $app application: $0 restart"
    echo ""
    echo -e "\t$BLU Ver el menu de ayuda ejecute$NC: $0 -h"
    echo ""
  exit 0
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
