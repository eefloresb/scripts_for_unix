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

# Busuqeda de archivos con el prefijo agent_sterr en adelante con un tamaño
# mayor a 100 Megas en sizing

DIRECTORY=/tmp

function _delete_with_find() {
  cd $DIRECTORY
  find . -size +100M -name "agent_stderr*" | while read line; do 
    #cat /dev/null > $line 
    echo $line
  done
}

_delete_with_find
