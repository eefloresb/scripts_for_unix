#!/bin/bash
## Autor: eflores@canvia.com 
## Licencia: gplv2
## DEFINE LOCAL VALUES
IP_SERVER="10.222.37.204"
HOSTNAME_SERVER=$(hostname)
RUTA_DIR_ORIGEN="/tmp/hyperion"
#DEFINE LOGS LOCALES
BACKUPLOG="/var/log/sapsftp/logsapcopy.log"
REMOTECOPYLOG="/var/log/sapsftp/copyremotestatus.log"
#DEFINE VALUES
COPY="copy"
STATUS="OK"
USER="sap_sftp"

## DEFINE REMOTE VALUES
REMOTE_SERVER="172.16.28.99"
PORT_REMOTE="21"
RUTA_DIR_DESTINO="C:\EPMAgent\AppFolder\data"
RESOURCE=""
USER_REMOTE="adminepm"
PASSWORD_REMOTE='S4p$jn@j12.'
DOMAIN_REMOTE="talmape"

_get_ftp(){
tempdir=$(mktemp)
cd $tempdir 
curl -T $xFIle -u ${DOMAIN_REMOTE}/${USER_REMOTE}:${PASSWORD_REMOTE} ftp://${REMOTE_SERVER}
if [[ $? == "0" ]]; then 

else
fi
sleep 5
}

_create_log(){

if id $USER &>/dev/null; then
	echo -n ""
else
	useradd -m -d /home/sap_sftp -s /bin/false -g users -G users -c "User to save log generates by script.sh" sap_sftp
fi

if [[ ! -d ${BACKUPLOG%/log*.log} ]]; then
  mkdir -p ${BACKUPLOG%/log*.log}
  chown -R $USER: ${BACKUPLOG}
fi

if [[ ! -f $BACKUPLOG ]];then 
  touch $BACKUPLOG
  chown $USER: ${BACKUPLOG}
fi 

if [[ ! -f $REMOTECOPYLOG ]];then 
  touch $REMOTECOPYLOG
  chown $USER: ${REMOTECOPYLOG}
fi 
}

###### GENERATE FILES WITH CONTENT TO COPY
_upload_data(){
local LOGTMP=$1
find * -name "*.txt" -prune -type f > $LOGTMP
}

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
  local DAYMONTHOUR=$(date "+%d/%B-%H:%M:%S")
    if [[ "$ERRPT" == '0' ]] & [[ "$BAND" == 'OK' ]]; then
        echo "$ROUTE,$COPY,${FILE},${REMOTE_SERVER},OK,${USER},$DAYMONTHOUR" >> $REMOTECOPYLOG
    elif [[ $ERRPT != '0' ]] & [[ "$BAND" == 'OK' ]]; then
          echo "$ROUTE,$COPY,${FILE},$REMOTE,FAILED,${USER},$DAYMONTHOUR" >> $REMOTECOPYLOG
    elif [[ $ERRPT == '0' ]] & [[ "$BAND" == 'FAILED' ]]; then 
          sed "/${FILE}/s/FAILED/$STATUS/g" $REMOTECOPYLOG > $REMOTECOPYLOG.tmp 
          mv $REMOTECOPYLOG.tmp $REMOTECOPYLOG
    else 
        echo "Mandar correo"
    fi
}

_ftp_connection(){
local FILE=$1
local FAILED=$2
local ROUTE=$(pwd)
curl -T $FILE -u ${DOMAIN_REMOTE}/${USER_REMOTE}:${PASSWORD_REMOTE} ftp://${REMOTE_SERVER}
ERRPT=$(echo $?)
sleep 5
_save_data_log $ERRPT $FAILED $FILE $ROUTE ${USER_REMOTE}
}

_copy_to_ftp_remote(){
  local xFile=$1
  local xBand=$2
  _sftp_connection $xFile $xBand
  #_remove_file $xFILE
}

_set_copy(){
local ROUTE=${RUTA_DIR_ORIGEN}
FAILED="OK"
cd $ROUTE
LOGTMP=$(_get_data)
while read xFILE; do
        if [[ -f $BACKUPLOG ]]; then 
            valorx=$(grep ${xFILE} $BACKUPLOG)
            if [[ $valorx != "" ]]; then 
                FAILED=$(echo $valorx|cut -d "," -f 5)
                  if [[ $FAILED == "FAILED" ]]; then
                    _ftp_connection $xFILE $FAILED
                  fi 
            else
                  _ftp_connection $xFILE $FAILED
            fi
        else
           _create_log       
          _ftp_connection $xFILE $FAILED
        fi
done < $LOGTMP
#_remove_file $LOGTMP
}

_set_copy

