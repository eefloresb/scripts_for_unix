#!/bin/bash 
# find /u01 -name "*.log" -size +1048576K -exec du -hs {} \;
#Dado esto, SI sería factible realizar un mantenimiento mensual a dichos archivos; siguiendo las siguientes secuencias:
#Borrar los backups de logs del mes pasado
#Sacar un backup de los logs mencionados y comprimirlos
#Vaciar el contenido de los archivos logs originales (cat /dev/null > listener.log)
DIR="/u01"
DATEDay=$(date +%d)
DATEMonth=$(date +%m)
DATEYear=$(date +%y)
cd $DIR
#Declare vector to find log
COMMANDFIND=($(find . -name "*.log" -size +1048576K))
#Mantenimiento Mensual 
_delete_logs(){
 find . -name "*.[0-9][0-9]_[0-9][0-9]_[0-9][0-9].log.gz" -mtime +30 -exec rm {} \;
}

# Sacar un backup semanal y comprimirlos 
_compress_logs(){
local FILE=$1
 gzip -c ${FILE} > ${FILE}.${DATEDay}_${DATEMonth}_${DATEYear}.log.gz
 cat /dev/null > ${FILE}
 echo "$file compress in ${HOSTNAME} in ${DATEDay}/${DATEMonth}/${DATEYear}" >> /var/log/log_rotate_u01.log
}

_main(){
    if [[ ! -z $COMMANDFIND ]]; then 
        for (( i=0; i<${#COMMANDFIND[@]}; i++ )); do
            _compress_logs ${COMMANDFIND[$i]}
        done
    fi
    _delete_logs
}

_main