#!/usr/bin/bash
_execute_script(){
    cd /scripts
    bash connect-upload-sftp.sh execute
    bash connect-upload-sftp.sh delete
}

_check_file_IN(){
cd /scripts
declare -i number=$(find /home/SCOTIA/FACTORING/AESA/IN -type f | wc -l)
if (( $number >=0 )); then 
    #exist the file new 
    _execute_script    
fi
}

_check_file(){
while true; do
sleep 1
#check if exist the file in IN
_check_file_IN
done
}

_check_file

