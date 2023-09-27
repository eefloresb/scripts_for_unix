#!/bin/bash
# Declarar variables
HTOP=$(which htop)
DATE=$(which date)
AHA=$(which aha)
RUTA="/var/log/htop/"
if [[ -z $HTOP ]]; then
  echo "instalar htop, en caso de rhel(epel release) en Debian Family(apt)"
  exit 0
elif [[ -z $AHA ]]; then 
  echo "Instalar el paquete aha"
  exit 0
fi
HORA=$($DATE +%m-%d-%Y_%R)
FICHERO="htop_file"
EXTENSION="html"
echo q | htop | aha --black --line-fix > "$RUTA${FICHERO}_$HORA.$EXTENSION"
