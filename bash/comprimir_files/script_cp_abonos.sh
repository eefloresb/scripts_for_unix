#!/bin/bash
yum install -y mlocate 
updatedb 
ROUTEDEST=/home/adcan_eflores
while read line;do
  ROUTE=$(locate $line)
  NAME=${ROUTE##/*/}
  gzip -c $ROUTE > $ROUTEDEST/$NAME.gz
done < list_files
