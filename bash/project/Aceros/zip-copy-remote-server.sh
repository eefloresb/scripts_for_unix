#Autor: eflores@canvia.com
#Licencia: gplv2
#!/bin/bash
declare -a MONTH=('enero' 'febrero' 'marzo' 'abril' 'mayo' 'junio' 'julio' 'agosto' 'setiembre' 'octubre' 'noviembre' 'diciembre')
USER="logsap"
COPY="copy"
STATUS="OK"
OS=$uname
DAY=$(date +%d)
DAYMONTH=$(date +%d%m)
DIRSCPEND="/usr/local/saplogs/logs/$HOSTNAME"
REMOTE="172.16.2.79"
BACKUPLOG="/var/log/logsap/logsapcopyremote.log"
REMOTECOPYLOG="/var/log/logsap/copyremotestatus.log"
DIRTMP="/var/tmp"

if [[ ! -f $BACKUPLOG ]];then 
  touch $BACKUPLOG
fi 
if [[ ! -f $REMOTECOPYLOG ]];then 
  touch $REMOTECOPYLOG
fi 

_get_month(){
NMONTH=$1
value=($(echo $NMONTH|awk -F "_" '{print $2}'|awk -v ORS="" '{ gsub(/./,"&\n") ; print }'))
NMONTH="${value[4]}${value[5]}"
  if [[ $NMONTH == "01" ]]; then echo ${MONTH[0]}; fi 
  if [[ $NMONTH == "02" ]]; then echo ${MONTH[1]}; fi 
  if [[ $NMONTH == "03" ]]; then echo ${MONTH[2]}; fi 
  if [[ $NMONTH == "04" ]]; then echo ${MONTH[3]}; fi 
  if [[ $NMONTH == "05" ]]; then echo ${MONTH[4]}; fi 
  if [[ $NMONTH == "06" ]]; then echo ${MONTH[5]}; fi 
  if [[ $NMONTH == "07" ]]; then echo ${MONTH[6]}; fi 
  if [[ $NMONTH == "08" ]]; then echo ${MONTH[7]}; fi 
  if [[ $NMONTH == "09" ]]; then echo ${MONTH[8]}; fi 
  if [[ $NMONTH == "10" ]]; then echo ${MONTH[9]}; fi 
  if [[ $NMONTH == "11" ]]; then echo ${MONTH[10]}; fi 
  if [[ $NMONTH == "12" ]]; then echo ${MONTH[11]}; fi 
}

_get_day(){
  NMONTH=$1
    local value=($(echo $NMONTH|awk -F "_" '{print $2}'|awk -v ORS="" '{ gsub(/./,"&\n") ; print }'))
    NMONTH=${value[6]}${value[7]}
    echo $NMONTH
}

_remove_file(){
  rFILE=$1
  rm $rFILE
}
_create_gzip(){
  FILE=$1
  gzip -c $FILE > $DIRTMP/$FILE.gz  
  FILE="$FILE.gz"
  echo "$DIRTMP/${FILE}"
}

  #Copy from origin to destination
_copy_remote(){
  local FILE=$1
  local BAND=$2
  local ROUTE=$3
  nday=$(_get_day $FILE)
  local value=($(echo $FILE|awk -F "_" '{print $2}'|awk -v ORS="" '{ gsub(/./,"&\n") ; print }'))
  local nmonth="${value[4]}${value[5]}"
  local MONTH=$(_get_month $FILE)
  local daymonth="$nday$nmonth"
    if [[  $daymonth != $DAYMONTH ]]; then
        local FILE=$(_create_gzip $FILE)
        FILETEMP=${FILE##/*/}
        ssh -f $USER@$REMOTE "if [[ ! -d $DIRSCPEND/$ROUTE/$MONTH ]]; then mkdir -p $DIRSCPEND/$ROUTE/$MONTH; fi"
        rsync -Pav -e "ssh -l logsap -i /home/logsap/.ssh/id_rsa" $FILE $USER@$REMOTE:$DIRSCPEND/$ROUTE/$MONTH/ 1>>$REMOTECOPYLOG 
        if [[ $? == '0' ]] & [[ $BAND == 'OK' ]]; then
            echo "$ROUTE,$COPY,${FILETEMP%.gz},$REMOTE,$STATUS" >> $BACKUPLOG
        elif [[ $? != '0' ]] & [[ $BAND == 'OK' ]]; then
              echo "$ROUTE,$COPY,${FILETEMP%.gz},$REMOTE,FAILED" >> $BACKUPLOG 
        elif [[ $? == '0' ]] & [[ $BAND == 'FAILED' ]]; then 
              sed "/${FILETEMP%gz}/s/FAILED/$STATUS/g" $BACKUPLOG > $BACKUPLOG.tmp 
              mv $BACKUPLOG.tmp $BACKUPLOG
        else 
            echo "Mandar correo"
        fi
        _remove_file $FILE
    fi
}

_upload_data(){
local LOGTMP=$1
find * -prune -name "audit_202[0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9]" -type f > $LOGTMP
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

_assigned_dir(){
  local ROUTE=$1
  ROUTE=$(echo ${ROUTE} | awk -F "/" '{print $5}')
  echo $ROUTE  
}

_set_copy(){
ROUTE=$1
FAILED="OK"
cd $ROUTE
ROUTE=$(_assigned_dir $ROUTE)
LOGTMP=$(_get_data)
while read xFILE; do
        if [[ -f $BACKUPLOG ]]; then 
            valorx=$(grep -Riw $ROUTE,$COPY,${xFILE} $BACKUPLOG)
            if [[ $valorx != "" ]]; then 
                FAILED=$(echo $valorx|cut -d "," -f 5)
                  if [[ $FAILED == "FAILED" ]]; then
                    _copy_remote $xFILE $FAILED $ROUTE
                  fi 
            else
                  _copy_remote $xFILE $FAILED $ROUTE
            fi
        else           
          _copy_remote $xFILE $FAILED $ROUTE
        fi
done < $LOGTMP
_remove_file $LOGTMP
}

_main(){
HOSTNAME=$(hostname)
if [[ $HOSTNAME == "erppicbd" ]]; then
  ROUTE="/usr/sap/PRD/D02/log/"
  _set_copy $ROUTE
elif [[ $HOSTNAME == "ERPPID04" ]]; then 
      ROUTE=("/usr/sap/PRD/D34/log" "/usr/sap/PRD/D36/log")
      for(( i=0; i<${#ROUTE[@]}; i++ )); do 
      _set_copy ${ROUTE[$i]}
      done
elif [[ $HOSTNAME == "ERPPID03" ]]; then
      ROUTE=("/usr/sap/PRD/D24/log" "/usr/sap/PRD/D26/log")
      for(( i=0; i<${#ROUTE[@]}; i++ )); do 
        _set_copy ${ROUTE[$i]}
      done
fi
}
_main