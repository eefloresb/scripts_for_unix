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

## En /etc/shadow, la contrase√±a (segundo campo) no se le puede asignar el valor nulo (: :) ya que esto permitir√≠a acceder 
## a la identificaci√≥n sin ingresar una contrase√±a o usar la contrase√±a 'vac√≠a' (nula).
#
cat /etc/shadow | awk -F ":" '($2 =="") {print $1}' |
  while read line; do 
      sed -e "/$line/s/::/:!!:/" /etc/shadow
  done
