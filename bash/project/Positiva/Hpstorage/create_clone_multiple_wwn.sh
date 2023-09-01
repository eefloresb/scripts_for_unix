#!/bin/bash
STORAGE=("192.168.1.200" "192.168.1.201" "192.168.1.202" "192.168.1.203" )
DATE=$(date +%y%m%d)
CRQ="4444"

funcion_archivo=programa
USER
REMOTESAN

COMMANDSSH=$(ssh admcanv01@10.100.100.98)
COMMANDEXE="\"lsvdisk -delim ,\""
LUNID="600507681080030848000000000000E9"
COMMFILTER="-filtervalue XXX="

NAMEZONE=$7
status=$X


"lsmdiskgrp -filtervalue name=\"$NAMEZONE\" -delim "

$COMMANDSSH|grep $WWN > archivo.txt 
sed -i '1d' archivo.txt 
mktemp()
{
  # Funcion que crea un archivo temporal
  #
  # Variables de ambito local
  local tmpfile RAND
  RAND=$(od -N4 -tu /dev/random | awk 'NR==1 {print $2} {}')
  tmpfile=/tmp/tmp.$(date +%d%m%Y%H%M%S).${RAND}
  touch $tmpfile
  echo $tmpfile
}

__create_volumen(){
    local CRQ=$1
    local DATE=$2
    local NAMEZONELUN=$3
    ssh $USER@$HOST "svctask mkvdisk -iogrp io_grp0 -mdiskgrp $NAMEZONELUN -name $VOLUMENAME_$DATE_$CRQ -node node1 -size $SIZELUN -unit b"
}

__flash_copy(){
#mkfcmap -autodelete -cleanrate 150 -copyrate 150 -source COT4_FS7200_ALPHADES_N_VGAUDIT_P01 -target COT4_FS7200_ALPHADES_N_VGAUDIT_P01_01
ssh $USER@$HOST \"mkfcmap -autodelete -cleanrate 150 -copyrate 150 -source $VOLUMENAME -target $VOLUMENAME_$DATE_$CRQ\"
}

__busqueda_lun_id(){
  declare -i CAPACITYLUN
  local tmpfilelun=$(mktemp)
  local tmpfilepool=$(mtemp)
  local LUNID=$1
  for HOST in ${STORAGE[@]}; do 
    #ssh admcanv01@10.100.100.98 "lsvdisk -delim , -filtervalue vdisk_UID=60050768108182E3A000000000000028"
    ssh $USER@$HOST \"lsvdisk -delim , -bytes -filtervalue vdisk_UID=$LUNID\" | tail -n +2 > $tmpfilelun
    if [[ ! -z $tmpfile ]]; then 
        NAMEZONELUN=$(cat $tmpfilelun | head -n +2 | awk ',' '{print $22}')
        SIZELUN=$(cat $tmpfilelun | head -n +2 | awk ',' '{print $8}')
        VOLUMENAME=$(cat $tmpfilelun | head -n +2 | awk ',' '{print $28}')
        # Extraes la data del pool
        #ssh admcanv01@10.100.100.98 "lsmdiskgrp -filtervalue name=FS7200 -delim ,"
        #ssh $USER@$HOST "lsmdiskgrp -filtervalue name=\"$NAMEZONE\" -bytes -delim ," | tail -n 1 
        STATUSPOOL=$(ssh $USER@$HOST "lsmdiskgrp -filtervalue name=\"$NAMEZONE\" -bytes -delim ," | tail -n 1 | awk -F "," $3)
        FREECAPACITYPOOL=$(ssh $USER@$HOST "lsmdiskgrp -filtervalue name=\"$NAMEZONE\" -bytes -delim ," | tail -n 1 | awk -F "," $7)
        if [[ $STATUS == "online" ]];
            FREECAPACITYPOOLIM=0.70*$FREECAPACITYPOOL
            if (( $CAPACITYLUN < $FREECAPACITYPOOLIM )); then         
                __create_volumen $CRQ $DATE $NAMEZONELUN $SIZELUN
                __flash_copy $CRQ $DATE $NAMEZONELUN
            else 
                echo no hay espacio
            fi
        else 
            echo error 
        fi
    fi
  done
}

__main(){

while read LUNID; do 
__busqueda_lun_id $LUNID
done < lista_lun_id.txt 

}

__main