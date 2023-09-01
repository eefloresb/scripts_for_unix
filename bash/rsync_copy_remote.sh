#!/bin/bash
RUTA="/SIED/FS/anexx/:/SIED/FS/main/:/SIED/FS/mainSignnetTemp/:/SIED/FS/read/:/SIED/FS/readSignnetTemp/:/SIED/FS/receive/:/SIED/FS/refext/:/SIED/FS/rubrica/:/SIED/FS/TD/:/SIED/FS/TD/xml/"
IPORIGEN=10.111.1.202
IPDEST=10.111.1.223
RSYNC=$(which rsync)
NAMERSYNC="files"

IFS=":"
for rutax in $RUTA; do
if [ -d $rutax ]; then
  cd $rutax
  echo $PWD
  $RSYNC -avzp $IPORIGEN::${NAMERSYNC}/${rutax#//} .
fi
done
