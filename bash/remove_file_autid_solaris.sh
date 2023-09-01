#!/usr/bin/bash
ROUTE="/var/share/audit"
DATE=$(date +%Y-%m-%d)
FILELOG="/var/adm/log/audit"

if [[ ! -f /var/adm/log/audit ]]; then
  touch $FILELOG
fi

__usage(){
  echo "**** rotate audit in $DATE ****"
}

__log(){
CADENA=$(cat /tmp/log)
if [[ ! -z $CADENA ]]; then
  echo $CADENA >> $FILELOG
fi
}

__restart(){
  svcadm disable auditd
  svcadm enable auditd
}

__rotate(){
local BAND=""
if [[ -d "$ROUTE" ]]; then
__usage >> $FILELOG
cd $ROUTE
BAND=$(ls -1 * |
    while read line; do
      declare -i myfilesize=$(stat --format=%s "$line")
          if (( $myfilesize/1024/1024/1024 > 1 )); then
            rm -fv $line > /tmp/log
            __log
            echo "true"
          fi
    done)
    if [[ ! -z $BAND ]]; then
        echo "reiniciando auditd..." >> $FILELOG
        __restart
    fi
else
        echo "$ROUTE not exist"
        exit 1
fi
}

__check_file_core
__rotate
