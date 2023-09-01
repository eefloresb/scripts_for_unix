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
REMOTE_IP_DESTINO="10.20.65.106"
#REMOTE_IP_DESTINO="192.168.56.14"
BACKUPLOG="/var/log/sapsftp/logsapcopyremote.log"
REMOTECOPYLOG="/var/log/sapsftp/copyremotestatus.log"
RUTA_DIR_ORIGEN="/tmp"
RUTA_DIR_DESTINO="/FTP"
KEY="/home/sap_sftp/.ssh/id_rsa"
HOSTNAME=$(hostname)
IPROUTE=$(ip route show | grep "default" | grep -Ewo "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+")
IPADDRESS=$(ip a s|grep -Eow $IPROUTE\.[[:digit:]]+\/[[:digit:]]+ | awk -F "/" '{print $1}')

_remove_file(){
  rFILE=$1
  rm $rFILE
}

_sftp_connection(){
local USER=$1
local PASSWORD=$2
local FILE=$3
local ROUTE=$4
local REMOTE=$5
sshpass -p $PASSWORD $SFTP -oPort=$PORT -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $USER@$REMOTE:/$ROUTE/<<EOF
put $FILE
EOF
}

_move_to_sftp_remote(){
  local xUSER=$1
  local xPASSWORD=$2
  local xFILE=$3
  local xRoute=$4
  local xREMOTE=$5
  _sftp_connection $xUSER $xPASSWORD $xFILE $xROUTE $xREMOTE
  _remove_file $xFILE
}

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
  local xHour=$(date "+%d-%m-%y %H:%M")
         ssh -f $USER@${REMOTE_IP_DESTINO} -i ${KEY} -q -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=yes -o PasswordAuthentication=no "if [[ ! -d ${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH ]]; then mkdir -p ${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH; fi"
  local RUTA_DIR_DESTINO="${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH"
        rsync -Pav -e "ssh -l $USER -i $KEY" $xFILE $USER@${REMOTE_IP_DESTINO}:${RUTA_DIR_DESTINO}/ 1>>$REMOTECOPYLOG 
        if [[ $? == '0' ]] & [[ $BAND == 'OK' ]]; then
            echo "$COPY,${xFILE},${REMOTE_IP_DESTINO},$STATUS,$xHour" >> $BACKUPLOG
            _remove_file $xFILE
        elif [[ $? != '0' ]] & [[ $BAND == 'OK' ]]; then
              echo "$COPY,${xFILE},$REMOTE,FAILED,$xHour" >> $BACKUPLOG 
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
FAILED="OK"
cd $ROUTE
LOGTMP=$(_get_data)
while read xFILE; do
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

##########################################################

_upload_sftp_cloud(){

  if [[ $HOSTNAME == "" ]] || [[ $IPADDRESS == "" ]]; then 
    cd $DIR
    IPADDRESS=""
    _move_to_sftp_remote 
  elif [[ $HOSTNAME == "" ]] || [[ $IPADDRESS == "" ]]; then 
    cd $DIR
    IPADDRESS=""
    _move_to_sftp_remote
  elif [[ $HOSTNAME == "" ]] || [[ $IPADDRESS == "" ]]; then 
    cd $DIR
    IPADDRESS=""
    _move_to_sftp_remote
  fi
}

###########################################################


_set_copy