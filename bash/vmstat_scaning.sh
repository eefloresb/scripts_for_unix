#!/bin/bash
export ARCHIVO=`date +%Y_%m_%d`
export HORA=`date +%H:%M`
export OUTPUT=/stage/output/${ARCHIVO}.log

if [[ ! -d /stage/output/ ]]
then 
    mkdir -p /stage/output/
fi
__scaning(){    
        echo                                >> ${OUTPUT}_vmstat.log
        declare -i xcpu=$(vmstat 1 1 | tail -n 1 | awk '$2 > 5 {print $2}')
        if (( $xcpu > 5 )) ; then 
            echo HORA $HORA    vmstat           >> ${OUTPUT}_vmstat.log
            echo $xcpu >> ${OUTPUT}_vmstat.log
            ps aux | awk '$8 ~ /^D/{print}' >> ${OUTPUT}_vmstat.log
            echo ----------------------------   >> ${OUTPUT}_vmstat.log
        fi
}
__scaning