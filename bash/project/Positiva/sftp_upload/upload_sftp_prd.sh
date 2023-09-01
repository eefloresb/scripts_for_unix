#!/bin/bash
## Autor: eflores@canvia.com 
## Licencia: gplv2
## /tmp/Solicitud_20100210909_20221207_01.txt
### SOPORTE DESARROLLO ###
## file1.TXT
## file2.TXT
## file3.TXT
## /tmp/Solicitud_20100210909_20221207_01.txt
## /tmp/Solicitud_20100210909_20221207_02.txt
## /tmp/Solicitud_20100210909_20221207_03.txt

USER="sap_sftp"
COPY="copy"
STATUS="OK"
OS=$uname
DAY=$(date +%d)
DAYMONTH=$(date +%d%m)
REMOTE_IP_DESTINO="10.10.30.161"
#REMOTE_IP_DESTINO="192.168.56.14"
BACKUPLOG="/var/log/sapsftp/logsapcopyremote.log"
REMOTECOPYLOG="/var/log/sapsftp/copyremotestatus.log"
RUTA_DIR_ORIGEN="/tmp"
#RUTA_DIR_DESTINO="/FTP"
RUTA_DIR_DESTINO="/Nexus"
#KEY="/home/sap_sftp/.ssh/id_rsa"
#KEY="/SAPDOCS/APP1/SPLA/SPLA_EG/.ssh/id_rsa"
KEY="/keys/id_rsa"

if [[ ! -f $BACKUPLOG ]];then 
  touch $BACKUPLOG
  chown $USER: ${BACKUPLOG}
fi 
if [[ ! -f $REMOTECOPYLOG ]];then 
  touch $REMOTECOPYLOG
  chown $USER: ${REMOTECOPYLOG}
fi 

_upload_data(){
local LOGTMP=$1   
#### el para
find * -name "Solicitud_*.txt" -prune -type f > $LOGTMP
}

#generate file random
_generate_file_random(){
RAND=$(od -N 4 -tu /dev/random | awk 'NR==1 {print $2}')
tmpfile=/tmp/temp.${RAND}
touch $tmpfile
_upload_data $tmpfile
echo $tmpfile
}

_get_data(){
local LOGTMP=$(_generate_file_random)
echo $LOGTMP
}

### Copia remotamente el archivo
_copy_remote(){
  local xFILE=$1
  local BAND=$2
  local xSTAT=$(echo ${xFILE}|awk -F "_" '{print $1}')
  local xRUC=$(echo ${xFILE}|awk -F "_" '{print $2}')
  local xDATE=$(echo ${xFILE}|awk -F "_" '{print $3}')
  local value=($(echo $xDATE|awk -v ORS="" '{ gsub(/./,"&\n") ; print }'))
  local xYEAR=${value[0]}${value[1]}${value[2]}${value[3]}
  local xMONTH=${value[4]}${value[5]}
  local xITEM=$(echo ${xFILE}|awk -F "_" '{print $4}')
         ssh -f $USER@${REMOTE_IP_DESTINO} -i ${KEY} -q -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=yes -o PasswordAuthentication=no "if [[ ! -d ${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH ]]; then mkdir -p ${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH; fi"
  local RUTA_DIR_DESTINO="${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH"
        rsync -Pav -e "ssh -l $USER -i $KEY" $xFILE $USER@${REMOTE_IP_DESTINO}:${RUTA_DIR_DESTINO}/ 1>>$REMOTECOPYLOG 
        if [[ $? == '0' ]] & [[ $BAND == 'OK' ]]; then
            echo "$COPY,${xFILE},${REMOTE_IP_DESTINO},$STATUS" >> $BACKUPLOG
            _remove_file $xFILE
        elif [[ $? != '0' ]] & [[ $BAND == 'OK' ]]; then
              echo "$COPY,${xFILE},$REMOTE,FAILED" >> $BACKUPLOG 
        elif [[ $? == '0' ]] & [[ $BAND == 'FAILED' ]]; then 
              sed "/${XFILE}/s/FAILED/$STATUS/g" $BACKUPLOG > $BACKUPLOG.tmp 
              mv $BACKUPLOG.tmp $BACKUPLOG
              _remove_file $xFILE
        else 
            echo "Mandar correo"
        fi
}

_set_copy(){
ROUTE="${RUTA_DIR_ORIGEN}"
cd $ROUTE
LOGTMP=$(_get_data)
while read xFILE; do
FAILED="OK"
        if [[ -f $BACKUPLOG ]]; then 
            valorx=$(grep ${xFILE} $BACKUPLOG)
            if [[ $valorx != "" ]]; then 
                FAILED=$(echo $valorx|cut -d "," -f 5)
                  if [[ $FAILED == "FAILED" ]]; then
                    _copy_remote $xFILE $FAILED
                  fi 
            else
                  _copy_remote $xFILE $FAILED
            fi
        else           
          _copy_remote $xFILE $FAILED
        fi
done < $LOGTMP
_remove_file $LOGTMP
}

_remove_file(){
  rFILE=$1
  rm $rFILE
}

_set_copy