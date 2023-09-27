#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Edwin Enrique Flores Bautista
# Email: eflores.unmsm.fisi@gmail.com

# Declarar variables
HTOP=$(which htop)
DATE=$(which date)
AHA=$(which aha)
RUTA="/var/log/htop/"
if [[ ! -d $RUTA ]]; then 
  mkdir $RUTA
fi
FILTER="-F java"
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
echo q | htop $FILTER | aha --black --line-fix > "$RUTA${FICHERO}_$HORA.$EXTENSION"
