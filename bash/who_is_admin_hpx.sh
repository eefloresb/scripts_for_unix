#!/usr/bin/env ksh
rm /tmp/usuarios.txt 
rm /tmp/users.txt
osname=$(uname)
band=0
ipaddr=$(netstat -in|grep -v 127.0.0.1|head -n 2|tail -n 1|awk -F " " '{print $4}') 
cat /etc/passwd|awk -F ":" '{print $1}' | while read user; do  sudo -l -U $user; done |grep -E "(ALL$|may run|su - root)" >> /tmp/users.txt
LOGTMP="/tmp/users.txt"
_return_description(){
    xUser=$1
    xDescription=$(cat /etc/passwd |grep $xUser | awk -F ":" '{print $5}')
    echo $xDescription
}
_select_data(){
cat /tmp/users.txt | while read line; do     
     if echo $line | grep "may run" 1>/dev/null ; then
        xUsuario=$(echo $line | awk -F " " '{print $2}')
        xDescription=$(_return_description $xUsuario)
     fi
     if echo $line | egrep -E -i "(ALL|root).*(ALL|root)" 1>/dev/null; then 
         band=1
      fi
     if [[ ! -z $xUsuario ]] && [[ $band -eq 1 ]]; then
        echo "$ipaddr,$xUsuario,$xDescription" >> /tmp/usuarios.txt
        xUsuario=""  
        xDescription=""      
        band=0
     fi 
done
cat /tmp/usuarios.txt
}

_select_data
