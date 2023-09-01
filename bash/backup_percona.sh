#!/bin/bash
#Autor: Enrique Flores
#Email: eflores.unmsm.fisi@gmail.com
# Se define backup full anual - mensual - semanal en xtrabackup para mysql-5.X
xtrabackup=$(which xtrabackup)
xdate=$(date +%y-%m-%d)
xlogf="logfile"
xdirb="/data/backups/base"
xuser="root"
xpass="password"
xvarl="/var/log"

### Despues de cada incremento debe generarse un full backup con la opcion prepare, se requiere validar que prepare sea nulo
#y pase como parametro sin afectar al comando, es decir si existe un inc reciente y se rota este debe anadir la opcion prepare 
__backup_full(){
echo "------------------------------------------------------" >> ${xvarl}/full-backup-${xlogf}.log
if [[ ! -d $xdirb ]]; then 
  xtrabackup --host=${host} --backup --user=${xuser} --password=${xpass} --target-dir=${xdirb} >> ${xvarl}/full-backup-${xlogf}.log
else 
  xtrabackup --prepare --apply-log-only --host=${host} --backup --user=${xuser} --password=${xpass} --target-dir=${xdirb} >> ${xvarl}/full-backup-${xlogf}.log
fi
echo "full backup from ${host} on ${xdate} in the full-backup-${xlogf}.log" >> ${xvarl}/full-backup-${xlogf}.log
echo "" >> ${xvarl}/full-backup-${xlogf}.log
}

##### crea directorios full backup - icrementales y full - incrementales pero cuando dichos directorios
##### existen estos deben tener la opcion --prepare y --apply-log-only a excepcion del ultimo
__incremental_diario(){
local ninc=$1
local type=$2
local ultimate=$3
local xdatem=$(date +%B)
#### pendiente revisar los mensuales 
  echo "------------------------------------------------------" >> ${xvarl}/incremental-backup-${xlogf}.log
if [[ $ninc = "1" ]]; then
  if [[ ! -d $xdirb/inc$ninc ]]; then 
    ${xtrabackup} --backup --target-dir=${xdirb}/inc${ninc} --incremental-lsn=$(xtrabackup --print-param --target-dir=${xdirb} | grep to_lsn | cut -d' ' -f3) >> ${xvarl}/incremental-backup-${xlogf}.log
  else 
    ${xtrabackup} --prepare --apply-log-only --target-dir=${xdirb}/inc${ninc} --incremental-lsn=$(xtrabackup --print-param --target-dir=${xdirb} | grep to_lsn | cut -d' ' -f3) >> ${xvarl}/incremental-backup-${xlogf}.log
  fi
else
  if [[ ! -d $xdirb/inc$ninc ]]; then
    ${xtrabackup} --backup --target-dir=${xdirb}/inc${ninc} --incremental-lsn=$(xtrabackup --print-param --target-dir=${xdirb}/inc${ninc} | grep to_lsn | cut -d' ' -f3) >> ${xvarl}/incremental-backup-${xlogf}.log
  else 
    if [[ $ultimate == "6" ]] && [[ $type == "diario" ]]; then 
      ${xtrabackup} --backup --target-dir=${xdirb}/inc${ninc} --incremental-lsn=$(xtrabackup --print-param --target-dir=${xdirb}/inc${ninc} | grep to_lsn | cut -d' ' -f3) >> ${xvarl}/incremental-backup-${xlogf}.log
    elif [[ $ultimate == "4" ]] && [[ $type == "semanal" ]]; then  
      ${xtrabackup} --backup --target-dir=${xdirb}/inc${ninc} --incremental-lsn=$(xtrabackup --print-param --target-dir=${xdirb}/inc${ninc} | grep to_lsn | cut -d' ' -f3) >> ${xvarl}/incremental-backup-${xlogf}.log
    elif \( [[ $ultimate == "27" ]] || [[ $ultimate == "28" ]] \) && \( [[ $type == "mensual" ]] && [[ $xdatem == "February" ]] \) ;then  
      ${xtrabackup} --backup --target-dir=${xdirb}/inc${ninc} --incremental-lsn=$(xtrabackup --print-param --target-dir=${xdirb}/inc${ninc} | grep to_lsn | cut -d' ' -f3) >> ${xvarl}/incremental-backup-${xlogf}.log
    else 
    ### pendinete considerar los 30 y 31 por meses 
      ${xtrabackup} --prepare --apply-log-only --target-dir=${xdirb}/inc${ninc} --incremental-lsn=$(xtrabackup --print-param --target-dir=${xdirb}/inc${ninc} | grep to_lsn | cut -d' ' -f3) >> ${xvarl}/incremental-backup-${xlogf}.log
    fi
  fi
fi
  echo "incremental $type ${ninc} backup from ${host} on ${xdate} in the incremental-backup-${xlogf}.log" >> ${xvarl}/incremental-backup-${xlogf}.log
  echo "" > ${xvarl}/incremental-backup-${xlogf}.log
}

__full_semanal_incremental_diario(){
  ninc=$(date +%w)
  if [[ ! -d $xdirb/base ]]; then 
        __backup_full
  elif [[ ${ninc} == "0" ]]; then
    __backup_full
  else 
    type="diario"
    declare -i ultimate=6
    __incremental_diario $ninc $type $ultimate
  fi
}
### %%%% se define como semana 4 valores, independimente si tiene 3 o mas %%%%%
### %%%% se almacena en un log el valor, dado que se usara como valor numerico de que semana este ubicado
### %%%% pasado las 4 semanas independimente del mes se reseteara el valor a 1 para iniciar el incremento 
# Mejora: En caso el cliente deseara fechas y dias exactos dentro del mes, se debe proporcionar un calendario para en funcion del mes crear el numero de incrementales_diarios por semana. 
__incremental_semanal(){
local type="semanal"
local xloginc = $xdirb/base/inc.log
if [[ ! -f $xloginc ]]; then
  touch $xdirb/base/inc.log
  echo 1 > $xdirb/base/inc.log
fi
declare -i variable=$(cat $xdirb/base/inc.log)
while (( $variable )); do
  if [[ $variable == 1 ]]; then
    __incremental_diario 1 $type 1
    echo 2 > $xdirb/base/inc.log
  elif [[ $variable == 2 ]]; then 
    __incremental_diario 2 $type 2
    echo 3 > $xdirb/base/inc.log
  elif [[ $variable == 3 ]]; then
    __incremental_diario 3 $type 3
    echo 4 > $xdirb/base/inc.log
  elif [[ $variable == 4 ]]; then 
    __incremental_diario 4 $type 4
    echo 1 > $xdirb/base/inc.log
  fi
  break
done
}
__full_mensual_incremental_semanal(){
  ninc=$(date +%w)
  xbegin=$(date +%d)
    if [[ $xbegin == "01" ]]; then
      __backup_full
    else
      if [[ $ninc == "0" ]]; then
        basels=$(ls -C1d ${xdirb}/base/* 2>/dev/null)
        if [[ -z $basels ]]; then
          __backup_full
        else
        __incremental_semanal
        fi
      fi
    fi
  done

}

__full_mensual_incremental_diario(){
month=$(date +%m)
day=$(date +%w)
if [[ -d $xdirb/base ]]; then 
      mkdir -p $xdirb/base
      __backup_full
else 
  ### que pasa si cae fin de mes, no esta considerando los full mensuales que caen el 01
  ### no cumple la regla dado que si el valor es 01, procede pero que pasa si es 10,20,30
  day=$(echo $day|grep |tr -d "0")
  if [[ ! -d $xdirb/base/inc$day ]]; then
      mkdir -p $xdirb/inc$day
  fi
  __incremental_diario $day diario
fi
}

__full_anual_incremental_mensual(){
  month=$(date +%m)
  day=$(date +%d)
  if [[ -d $xdirb/base ]]; then 
        mkdir -p $xdirb/base
        __backup_full
  elif [[ $month == "01" ]]; then 
    if [[ $day == "01" ]]; then 
      __backup_full
    fi
  else 
    ### Que pasa si lo ejecutamos en un mes por ejemplo 11
      if [[ $day == "01" ]]; then
        declare -i ninc=$(echo $month|tr -d "0")
        ninc=$((ninc-1))
        __incremental_diario $ninc mensual
      fi
  fi
}
