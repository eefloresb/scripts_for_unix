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
# Email: eflores@canvia.com

# Desarrollado para el equipo de monitoreo para obtener un dato real en equipo UNIX 

mktemp()
{ 
  # Funcion que crea un archivo temporal
  #
  # Variables de ambito local
  local tmpfile RAND
  RAND=$(od -N4 -tu /dev/random | awk 'NR==1 {print $2} {}')
  tmpfile=/tmp/tmp.$(date +%d%m%Y%H%M%S).${RAND}
  touch $tmpfile
  echo $tmpfile
}

# Registrar el sistema operativo
OS=$(uname)

# Crear archivo temporal
tmp=$(mktemp)

if [ "$OS" = "Linux" ]
then
  free -k > $tmp
  #
  # Si contiene "available", es la nueva version del comando free sin "buffers/cache"
  if grep -qi "available" $tmp
  then
    free=$(grep '^Mem' $tmp | awk '{ print $7 }')
  # Si no contiene "available", es la antigua version del comando free con "buffers/cache"
  else
    declare -i total=$(grep '^Mem' $tmp | awk '{ print $2 }')
    declare -i used=$(grep 'buffers/cache' $tmp | awk '{ print $3 }')
    declare -i free=$((total - $used))
  fi
  rm -f $tmp
  exit $free
  # Retornar el porcentaje de memoria usada como codigo de salida
fi
