#!/bin/bash 

function _change_passwd(){
USER=$1
PASSWD=$2 
echo "$USER:$PASSWD" | chpasswd
} 

function _disable_suscription(){
 ./check_so_vagrant.sh unregister 
}

function _capture_data(){
  line=$(grep -E "passwd" ./passwd.txt)
  USER= $(echo $line | awk -F ":" '{print $2}')
  PASSWD=$(echo $line | awk -F ":" '{print $3}')
  _change_passwd $USER $PASSWD
}

case $1 in 
    _disable_sus)
      _disable_suscription
    ;;
    _passwd)
      _capture_data passwd
    ;;
    *)
      ./check_so_vagrant.sh
      _capture_data passwd
esac
