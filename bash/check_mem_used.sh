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

# Desarrollado para el equipo de monitoreo me permite retornar el sizing de la memoria usada con el cual tienes
# un valor exacto de la memoria usada y disponible
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

_get_memory(){
  local mem
  if [[ $(which lsmem 2>/dev/null) ]]; then
    memoriaTotal=$(lsmem|grep "Total online"|grep -Eo "([[:digit:]]\.?)+")
    sizeType=$(lsmem|grep "Total online"|grep -Eo "([[:digit:]]\.?)+[[:alpha:]]"|grep -Eo "[[:alpha:]]")
    if [[ $sizeType == "M" ]]; then
      echo "$memoriaTotal 1024" | awk '{printf "%.2f\n", $1 * $2}'
    elif [[  $sizeType == "G" ]]; then
      echo "$memoriaTotal 1048576" | awk '{printf "%.2f\n", $1 * $2}'
    elif [[  $sizeType == "T" ]]; then
      echo "$memoriaTotal 1073741824" | awk '{printf "%.2f\n", $1 * $2}'
    fi
  else
    memoriaTotal=$(($(free -k | grep ^Mem|awk -F " " '{print $2}')+1))
    echo $memoriaTotal
  fi
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
  total=$(_get_memory)
  then
    free=$(grep '^Mem' $tmp | awk '{ print $7 }')
  # Si no contiene "available", es la antigua version del comando free con "buffers/cache"
  else
    declare -i total=$(grep '^Mem' $tmp | awk '{ print $2 }')
    declare -i used=$(grep 'buffers/cache' $tmp | awk '{ print $3 }')
    declare -i free=$total - $used
  fi
  rm -f $tmp
  resultado=$(echo "$free 100" | awk '{printf "%.2f\n", $1 * $2}')
  resultado=$(echo "$resultado $total" | awk '{printf "%.2f\n", $1 / $2}')
  resultado=$(echo "100 $resultado" | awk '{printf "%.2f\n", $1 - $2}')
  echo $resultado
  #echo $((100 - (($free*100/$total)) ))
  # Retornar el porcentaje de memoria usada como codigo de salida
fi