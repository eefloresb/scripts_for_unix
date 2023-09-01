#!/bin/bash 
#Autor: Edwin Flores
#Email: eflores@canvia.com
#License: gplv2
#Solo para detallar lo anterior, hay dos servidores:
#PRD: 10.80.5.30
#QAS: 10.80.5.29
#La IP del servidor SFTP destino :  190.116.5.24
#usftp834            MPfG2WtA
#usftp373            zMmCI3yd
#usftp840            JF0gwRVa
#usftp378            Pendiente Password
#Esta pendiente el otro usuario
export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
REMOTECOPYLOG="copyremotestatus.log"
COPYFILELOG="logsapcopyremote.log"
DIRLOG="/var/log/sap_sftp"
USER="sap_sftp"
BACKUPDIR="/var/backup"
_create_log(){
if id $USER &>/dev/null; then
        echo -n ""
else
        useradd -m -d /home/sap_sftp -s /bin/false -g users -G users -c "User to save log generates by upload_ftp.sh" sap_sftp
fi
if [[ ! -d $BACKUPDIR ]]; then 
   mkdir -p $BACKUPDIR
   chown $USER: $BACKUPDIR
fi 
}

FILECREDENTIALS="/etc/credentials"
ROUTE="/home/SCOTIA/FACTORING/AESA:/home/SCOTIA/FACTORING/TASA"
RUTAORIGEN="/home/SCOTIA/FACTORING"
SFTP=$(which sftp)
PORT="22"
REMOTE="190.116.5.24"
DESTCOPY="/nfshome/sbpftp04"
STATUS="OK"
COPY="Copy"
DOWNLOAD="Download"
HOSTNAME=$(hostname)

_remove_backup(){
cd $BACKUPDIR
find . -maxdepth 1 -type f | sort -n | head -n -150 | xargs rm -f
}

_remove_file(){
  rFILE=$1
  ROUTE=$2
  USER=$3
  if [[ ! -d $BACKUPDIR/$USER/$ROUTE ]]; then 
    mkdir -p $BACKUPDIR/$USER/$ROUTE
  fi
  mv $rFILE $BACKUPDIR/$USER/$ROUTE
  
}

_generate_file_random(){
RAND=$(od -N 4 -tu /dev/random | awk 'NR==1 {print $2}')
tmpfile=/tmp/temp.${RAND}
touch $tmpfile
echo $tmpfile
}

_get_data(){
local LOGTMP=$(_generate_file_random)
echo $LOGTMP
}

_get_sftp(){
local ROUTE=$1
local USER=$2
local PASSWORD=$3
#sshpass -p $PASSWORD $SFTP -oPort=$PORT -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE <<EOF
if [[ $USER == "usftp834" ]] || [[ $USER == "usftp373" ]]; then
local DESTCOPY=/nfshomedesa/
sshpass -p $PASSWORD $SFTP -oPort=$PORT  $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE <<EOF
ls -1
EOF
elif [[ $USER == "usftp840" ]]; then 
local DESTCOPY=/
sshpass -p $PASSWORD $SFTP -oPort=$PORT  $USER@$REMOTE:$DESTCOPY$ROUTE <<EOF
ls -1
EOF
elif [[ $USER == "usftp378" ]]; then
local DESTCOPY=/nfshome/sbpftp04/usftp378/
sshpass -p $PASSWORD $SFTP -oPort=$PORT  $USER@$REMOTE:$DESTCOPY$ROUTE <<EOF
ls -1
EOF
else 
  echo "Usuarios invalidos, contactar a eflores@canvia.com"
  exit 0 
fi
sleep 1
}

_get_sftp_data(){
local ROUTE=$1
local USER=$2
local PASSWORD=$3
local LOGTMP=$(_get_data)
local LOGTMP1=$(_get_data)
local LOGTMP2=$(_get_data)
_get_sftp $ROUTE $USER $PASSWORD > $LOGTMP1
tail -n +3 $LOGTMP1 > $LOGTMP2
cat $LOGTMP2 > $LOGTMP
echo $LOGTMP
}

_download_sftp(){
local xFILE=$1
local STATUS=$2
local REMOTECOPYLOG=$3
local ROUTE=$4
local USER=$5
local PASSWORD=$6
if [[ $USER == "usftp834" ]] || [[ $USER == "usftp373" ]]; then
local DESTCOPY=/nfshomedesa
sshpass -p $PASSWORD $SFTP $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE <<EOF
get $xFILE
EOF
sshpass -p $PASSWORD $SFTP $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE <<EOF
rm $xFILE
EOF
elif [[ $USER == "usftp840" ]]; then 
local DESTCOPY=/
sshpass -p $PASSWORD $SFTP $USER@$REMOTE:$DESTCOPY$ROUTE <<EOF
get $xFILE
EOF
sshpass -p $PASSWORD $SFTP $USER@$REMOTE:$DESTCOPY/$ROUTE <<EOF
rm $xFILE
EOF
elif [[ $USER == "usftp378" ]]; then 
local DESTCOPY=/nfshome/sbpftp04/usftp378/
sshpass -p $PASSWORD $SFTP $USER@$REMOTE:$DESTCOPY$ROUTE <<EOF
get $xFILE
EOF
sshpass -p $PASSWORD $SFTP $USER@$REMOTE:$DESTCOPY/$ROUTE <<EOF
rm $xFILE
EOF
else 
echo "Usuarios invalidos, contactar a eflores@canvia.com"
exit 0 
fi
ERRPT=$(echo $?)
sleep 1
#echo "$ROUTE,$DOWNLOAD,${FILE},$REMOTE,$STATUS,${USER}" >> $REMOTECOPYLOG
_save_data_log $ERRPT,$BAND,$ROUTE,$REMOTECOPYLOG >> $REMOTECOPYLOG
}

_busqueda_en_log(){
 local ROUTE=$1 
 local STATUSLOGCOPY=$2
 local USER=$3
 local PASSWORD=$4
 cd $ROUTE
 ls
  if [[ "$ROUTE" == "OUT" ]]; then
   LOGTMP=$(_get_sftp_data $ROUTE $USER $PASSWORD)
 else
   LOGTMP=$(_get_data)
   ls -C1 > $LOGTMP   
 fi
 local FAILED="OK"
 while read xFILE; do
        echo $xFILE
        if [[ -f $STATUSLOGCOPY ]]; then 
            valorx=$(grep ${xFILE} $STATUSLOGCOPY)
            if [[ $valorx != "" ]]; then 
                FAILED=$(echo $valorx|cut -d "," -f 5)
                    if [[ $ROUTE == "OUT" ]]; then
                        _download_sftp $xFILE $FAILED $STATUSLOGCOPY $ROUTE $USER $PASSWORD
                    else
                        _copy_remote $xFILE $FAILED $STATUSLOGCOPY $ROUTE $USER $PASSWORD
                    fi
            else
                    if [[ $ROUTE == "OUT" ]]; then
                      _download_sftp $xFILE $FAILED $STATUSLOGCOPY $ROUTE $USER $PASSWORD
                    else
                      _copy_remote $xFILE $FAILED $STATUSLOGCOPY $ROUTE $USER $PASSWORD
                    fi
            fi
        else
        touch $BACKUPLOG
            if [[ $ROUTE == "OUT" ]]; then
              _download_sftp $xFILE $FAILED $STATUSLOGCOPY $ROUTE $USER $PASSWORD
            else
             _copy_remote $xFILE $FAILED $STATUSLOGCOPY $ROUTE $USER $PASSWORD
            fi
        fi
  done < $LOGTMP
cd ..
}

_compare_data_vs_file_log(){
local ROUTE=$1
local USER=$2
local PASSWORD=$3
cd $ROUTE
for i in $(ls -C1); do
  if [[ ! -d "$DIRLOG/$i" ]] || [[ ! -f $DIRLOG/$i/$REMPOTECOPYLOG]] || [[ ! -f "$DIRLOG/$i/$COPYFILELOG" ]]; then
          mkdir -p "$DIRLOG/$i"
          touch "$DIRLOG/$i/$REMPOTECOPYLOG"
          touch "$DIRLOG/$i/$COPYFILELOG"
  fi  
  local STATUSLOGCOPY="$DIRLOG/$i/$COPYFILELOG"
  if [[ "$i" == "IN" ]]; then 
   _busqueda_en_log $i $STATUSLOGCOPY $USER $PASSWORD
  elif [[ "$i" == "OUT" ]]; then
    _busqueda_en_log $i $STATUSLOGCOPY $USER $PASSWORD
  elif [[ "$i" == "BKP" ]]; then
     _busqueda_en_log $i $STATUSLOGCOPY $USER $PASSWORD
  fi  
done
cd ..
}

_compare_data_vs_sftp_data(){
#_get_sftp_data $i $BACKUPLOG $USER $PASSWORD
local ROUTE=$1
local BACKUPFILELOG=$2
local USER=$3
local PASSWORD=$4
if [[ ! -f $BACKUPFILELOG ]]; then 
  touch $BACKUPFILELOG
fi
LOGTMP1=$BACKUPFILELOG
LOGTMP2=$(_get_data)
LOGTMP3=$(_get_data)
$(_get_sftp $ROUTE $USER $PASSWORD) > $LOGTMP2
tail -n +3 $LOGTMP2 > $LOGTMP3
mv $LOGTMP3 $LOGTMP2
while read line; do 
  if ! grep -w $line $LOGTMP1; then 
      _compare_data_vs_file_log $ROUTE $line
  fi
done < $LOGTMP2
}

_sftp_connection(){
local USER=$1
local PASSWORD=$2
local FILE=$3
local ROUTE=$4
#sshpass -p $PASSWORD $SFTP -oPort=$PORT -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE/<<EOF
if [[ $USER == "usftp834" ]] || [[ $USER == "usftp373" ]]; then
local DESTCOPY=/nfshomedesa
sshpass -p $PASSWORD $SFTP -oPort=$PORT $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE/<<EOF  
put $FILE
EOF
elif [[ $USER == "usftp840" ]]; then 
local DESTCOPY=/
sshpass -p $PASSWORD $SFTP -oPort=$PORT $USER@$REMOTE:$DESTCOPY$ROUTE/<<EOF  
put $FILE
EOF
elif [[ $USER == "usftp378" ]]; then 
local DESTCOPY=/nfshome/sbpftp04/usftp378/
sshpass -p $PASSWORD $SFTP -oPort=$PORT $USER@$REMOTE:$DESTCOPY$ROUTE/<<EOF  
put $FILE
EOF
else 
echo "Usuarios invalidos, contactar a eflores@canvia.com"
exit 0 
fi
sleep 1
}

_save_data_log(){
  local ERRPT=$1
  local BAND=$2
  local ROUTE=$3
  local REMOTECOPYLOG=$4
  local xHour=$(date "+%d-%m-%y %H:%M")
  if [[ $ROUTE != "OUT" ]]; then
    if [[ "$ERRPT" == '0' ]] & [[ "$BAND" == 'OK' ]]; then
        echo "$ROUTE,$COPY,${FILE},$REMOTE,$STATUS,${USER},$xHour" >> $REMOTECOPYLOG
    elif [[ $? != '0' ]] & [[ "$BAND" == 'OK' ]]; then
          echo "$ROUTE,$COPY,${FILE},$REMOTE,FAILED,${USER},$xHour" >> $REMOTECOPYLOG
    elif [[ $? == '0' ]] & [[ "$BAND" == 'FAILED' ]]; then 
          sed "/${FILE}/s/FAILED/$STATUS/g" $REMOTECOPYLOG > $REMOTECOPYLOG.tmp 
          mv $REMOTECOPYLOG.tmp $REMOTECOPYLOG
    else 
        echo "Mandar correo"
    fi
  else
    echo "$ROUTE,$DOWNLOAD,${FILE},$REMOTE,$STATUS,${USER}" >> $REMOTECOPYLOG
  fi
}

_copy_remote(){
  local FILE=$1
  local BAND=$2
  local REMOTECOPYLOG=$3
  local ROUTE=$4
  local USER=$5
  local PASSWORD=$6
  _sftp_connection $USER $PASSWORD $FILE $ROUTE
  local ERRPT=$?
  _save_data_log $ERRPT $BAND $ROUTE $REMOTECOPYLOG
  _remove_file $FILE $ROUTE $USER
}

_upload_data(){
  local LOGTMP=$1
  find * -type f > $LOGTMP
}

_assigned_values(){ 
    cd $RUTAORIGEN
    IPROUTE=$(ip route show | grep "default" | grep -Ewo "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+")
    IPADDRESS=$(ip a s|grep -Eow $IPROUTE\.[[:digit:]]+\/[[:digit:]]+ | awk -F "/" '{print $1}')
    if [[ $IPADDRESS == "10.80.5.29" ]]; then 
        ENVT="QA"
        ls -C1 | while read ROUTE; do 
          if [[ $ROUTE == "TASA" ]]; then   
            USER="usftp373"
            PASSWORD="zMmCI3yd"       
            _compare_data_vs_file_log $ROUTE $USER $PASSWORD
          elif [[ $ROUTE == "AESA" ]]; then
            USER="usftp834"
            PASSWORD="MPfG2WtA"
            _compare_data_vs_file_log $ROUTE $USER $PASSWORD
          else 
            echo "" > /dev/null;
          fi
        done
    elif [[ $IPADDRESS == "10.80.5.30" ]]; then
        ENVT="PRD"
        ls -C1 | while read ROUTE; do
          if [[ "$ROUTE" == "TASA" ]]; then 
            USER="usftp378"
            PASSWORD="AXa4nBgD33"
            _compare_data_vs_file_log $ROUTE $USER $PASSWORD
          elif [[ "$ROUTE" == "AESA" ]]; then 
            USER="usftp840"
            PASSWORD="JF0gwRVa"
            _compare_data_vs_file_log $ROUTE $USER $PASSWORD
          else 
            echo "the machine not is selection to execute it script"
            exit 0
          fi
        done
    fi 
}

_MAIN(){
  local expresion=$1
  case $expresion in 
  "execute")
    _assigned_values;;
  "delete")
    _remove_backup;;
  esac
}

_MAIN $1