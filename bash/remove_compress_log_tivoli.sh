#!/usr/bin/sh
ROUTE="/usr/tivoli/tsm/client/ba/bin64"
function __compress {
cd $ROUTE
ls -1 *.log | 
  while read line; do 
    gzip -c ${line} > ${line}_$(date +%y-%d-%m).gz
    cat /dev/null > ${line}
  done
}

function __delete {
cd $ROUTE
  find . -name "*.log.gz" -mtime +30 -exec rm -if {} \;
}

case "$1" in
    -c)
      __compress
      ;;
    -d)
      __delete
      ;;
esac
