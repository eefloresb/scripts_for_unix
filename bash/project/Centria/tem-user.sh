#!/bin/bash

i="OUT"
BACKUPLOG="/var/log/sapsftp/logsapcopyremote.log"
USER="usftp834"
PASSWORD="MPfG2WtA"

_get_sftp(){
local ROUTE=$1
local USER=$2
local PASSWORD=$3
sshpass -p $PASSWORD $SFTP -oPort=$PORT $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE <<EOF
ls -1
EOF
}

_get_sftp_data(){
local ROUTE=$1
local LOGTMP=$(_get_data)  
$(_get_sftp) > $LOGTMP
for (( i=0;i<${#value[@]};i++)); do
    if (( $i == "0" || $i == "1" )); then 
        continue
    fi
    echo ${value[$i]} >> $LOGTMP
done < $LOGTMP
echo $LOGTMP
}

 _get_sftp_data $i $BACKUPLOG $USER $PASSWORD