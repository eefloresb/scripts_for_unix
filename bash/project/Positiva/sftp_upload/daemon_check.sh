#!/usr/bin/bash

_execute_script(){
cd /scripts
bash upload_remote_sftp.sh
}

_check_file(){
while true; do
sleep 1
_execute_script
done
}

_check_file
