#/bin/bash

local DIR="/var/chroot/log/tomcat"
cd $DIR
ls -C1 | while read line; do 
        zipfile=$(echo $line | awk '{print $2}' | grep -Eiw ".*[[:digit:]]+-[0-9][1-9]-[0-9][1-9].log")
        gzip $zipfile
done 
    
