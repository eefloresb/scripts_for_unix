#!/bin/bash
# License: gplv2 
# Script que te permite rotar logs de la forma 
#ls -C1 | grep -E "*-2023-[0-9][0-9]-[0-9][0-9].log" 
# Se programo porque el /var/chroot/log tiene permisos 775 debido a un setfacl configurado
# lo que al intentar realizar logrotate -f te indica que tienes que cambiar de usuario 
# el script toma el valor actual de la fecha y el valor futuro para hacer una secuencia y con 
# ella poder sacar todos los ficheros con el nombre anteriormente mencionado.
cd /var/chroot/log/tomcat
start_year=2023
current_year=$(date +"%Y")
current_day=$(date +"%d")
current_month=$(date +"%m")

for year in $(seq $start_year $current_year); do
  for month in $(seq -w 01 12); do
    # Determine the last day of the month
    # Determina los días que tiene un mes en función del número del presente mes.
    if [[ "$month" == "04" || "$month" == "06" || "$month" == "09" || "$month" == "11" ]]; then
      lastday=30
    elif [[ "$month" == "02" ]]; then
      # This checks for leap year
      if (( year % 4 == 0 && ( year % 100 != 0 || year % 400 == 0 ) )); then
        lastday=29
      else
        lastday=28
      fi
    else
      lastday=31
    fi

    # Create a tarball for each day of the month
    for day in $(seq -w 01 $lastday); do
    if [[ $day != $current_day ]] || [[ $month != $current_month ]]; then
      filename=$(find . -name "*.${year}-${month}-${day}.log")
      if [[ -f "$filename" ]] && [[ ! -z "$filename" ]]; then
        gzip $filename
      fi
    fi
    done
  done
done


############## - con funciones declaradas - ##################
#!/bin/bash
# License: gplv2 
LOG_DIR="/opt/aci/Platform1/log/icexs1"
LOG_RM="/var/log/remove_files_rotate.log"

__compress(){
cd $LOG_DIR
start_year=2023
current_year=$(date +"%Y")
current_day=$(date +"%d")
current_month=$(date +"%m")

for year in $(seq $start_year $current_year); do
for month in $(seq -w 01 12); do
    if [[ "$month" == "04" || "$month" == "06" || "$month" == "09" || "$month" == "11" ]]; then
    lastday=30
    elif [[ "$month" == "02" ]]; then
    if (( year % 4 == 0 && ( year % 100 != 0 || year % 400 == 0 ) )); then
        lastday=29
    else
        lastday=28
    fi
    else
    lastday=31
    fi
    for day in $(seq -w 01 $lastday); do
    if [[ $day != $current_day ]] || [[ $month != $current_month ]]; then
    filename=$(find . -name "log${year}${month}${day}.txt")
    if [[ -f "$filename" ]] && [[ ! -z "$filename" ]]; then
        gzip $filename
    fi
    fi
    done
done
done
}

__delete_compress(){
    cd $LOG_DIR
    find . -type f -mtime +0 -name "*.gz" -exec rm -v {} \; >> $LOG_RM
}

case $1 in 
    compress)
        __compress 
    ;;
    delete)
        __delete_compress
    ;;
      *)
        echo "Usage: $0 {compress|delete}"
        exit 1
esac


######################## - del tipo vmcore_20230511_{1,2,3,4,5}.log 
#!/bin/bash
# License: gplv2 
LOG_DIR="/root/"
LOG_RM="/var/log/remove_files_rotate.log"

__compress(){
cd $LOG_DIR
start_year=2023
current_year=$(date +"%Y")
current_day=$(date +"%d")
current_month=$(date +"%m")

for year in $(seq $start_year $current_year); do
for month in $(seq -w 01 12); do
    if [[ "$month" == "04" || "$month" == "06" || "$month" == "09" || "$month" == "11" ]]; then
    lastday=30
    elif [[ "$month" == "02" ]]; then
        if (( year % 4 == 0 && ( year % 100 != 0 || year % 400 == 0 ) )); then
            lastday=29
        else
            lastday=28
        fi
    else
    lastday=31
    fi
    for day in $(seq -w 01 $lastday); do
    if [[ $day != $current_day ]] || [[ $month != $current_month ]]; then
    filename=($(find . -name "vmoper_${year}${month}${day}_?.log"))
        for (( k=0; k < ${#filename[@]}; k++ )); do 
            if [[ -f "${filename[$k]}" ]] && [[ ! -z "${filename[$k]}" ]]; then
                echo ${filename[$k]}
            fi
        done
    fi
    done
done
done
}

__delete_compress(){
    cd $LOG_DIR
    find . -type f -mtime +0 -name "*.gz" -exec rm -v {} \; >> $LOG_RM
}

case $1 in 
    compress)
        __compress 
    ;;
    delete)
        __delete_compress
    ;;
      *)
        echo "Usage: $0 {compress|delete}"
        exit 1
esac
