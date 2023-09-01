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
SFTP=$(which sftp)
OS=$uname
DAY=$(date +%d)
DAYMONTH=$(date +%d%m)
USER_REMOTE="inter_sftp"
PASSWORD_REMOTE="lapositiva123#"
PORT_REMOTE="2294"
REMOTE_SERVER="190.196.71.101"
REMOTE_DIR_DEST="/Recepcion/Solicitudes"
BACKUPLOG="/var/log/sapsftp/logsapcopy.log"
REMOTECOPYLOG="/var/log/sapsftp/copyremotestatus.log"
HOSTNAME=$(hostname)
RUTA_DIR_ORIGEN="/Nexus/Solicitud"

#_remove_file(){
#  rFILE=$1
#  rm $rFILE
#}
mkdir -p /var/log/sapsftp/
_create_log(){
if [[ ! -f $BACKUPLOG ]];then
  touch $BACKUPLOG
  chown $USER: ${BACKUPLOG}
fi
}
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

_save_data_log(){
  local ERRPT=$1
  local BAND=$2
  local FILE=$3
  local ROUTE=$4
  local USER=$5
    if [[ "$ERRPT" == '0' ]] & [[ "$BAND" == 'OK' ]]; then
        echo "$ROUTE,$COPY,${FILE},$REMOTE,OK,${USER}" >> $REMOTECOPYLOG
    elif [[ $ERRPT != '0' ]] & [[ "$BAND" == 'OK' ]]; then
          echo "$ROUTE,$COPY,${FILE},$REMOTE,FAILED,${USER}" >> $REMOTECOPYLOG
    elif [[ $ERRPT == '0' ]] & [[ "$BAND" == 'FAILED' ]]; then
          sed "/${FILE}/s/FAILED/$STATUS/g" $REMOTECOPYLOG > $REMOTECOPYLOG.tmp
          mv $REMOTECOPYLOG.tmp $REMOTECOPYLOG
    else
        echo "Mandar correo"
    fi
}

_sftp_connection(){
local FILE=$1
local FAILED=$2
local ROUTE=$3
sshpass -p ${PASSWORD_REMOTE} $SFTP -oPort=${PORT_REMOTE} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${USER_REMOTE}@${REMOTE_SERVER}:${REMOTE_DIR_DEST}<<EOF
put $FILE
EOF
ERRPT=$(echo $?)
sleep 5
_save_data_log $ERRPT $FAILED $FILE $ROUTE ${USER_REMOTE}
}

_copy_to_sftp_remote(){
  local xFile=$1
  local xBand=$2
  local xRoute=$3
  _sftp_connection $xFile $xBand $xRoute
  #_remove_file $xFILE
}

_set_copy(){
local RUTA=${RUTA_DIR_ORIGEN}
local ROUTE=$1
FAILED="OK"
cd $ROUTE
LOGTMP=$(_get_data)
while read xFILE; do
local xROUTE=${xFILE%%/Solicitud*}
local xFILE=${xFILE##*/}
cd $RUTA/$xROUTE
        if [[ -f $BACKUPLOG ]]; then
            valorx=$(grep ${xFILE} $BACKUPLOG)
            if [[ $valorx != "" ]]; then
                FAILED=$(echo $valorx|cut -d "," -f 5)
                  if [[ $FAILED == "FAILED" ]]; then
                    _copy_to_sftp_remote $xFILE $FAILED $ROUTE
                  fi
            else
                  _copy_to_sftp_remote $xFILE $FAILED $ROUTE
            fi
        else
           _create_log
          _copy_to_sftp_remote $xFILE $FAILED $ROUTE
        fi
done < $LOGTMP
#_remove_file $LOGTMP
}

_upload_sftp_cloud(){
  local RUTA=${RUTA_DIR_ORIGEN}
  _set_copy $RUTA
}

_upload_sftp_cloud

