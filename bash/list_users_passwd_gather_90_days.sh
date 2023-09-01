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

# Listado de usuarios con password mayor a 90 días
LOGUSERS=/tmp/usuariosx90.log 
cat /etc/passwd | \
  awk -F ":" '($7!="/sbin/nologin"&&$7!="/sbin/shutdown"&&$7!="/bin/sync"&&$7!="/sbin/halt") {print $1}' | \
  while read line; do grep -w $line /etc/shadow | awk -F ":" '$5>=91 {print $1}'; done > $LOGUSERS

if [ -f $LOGUSERS ]; then 
  while read line; do 
    chage -m 30 -M 90 -W 7 -I 0 $line
  done < $LOGUSERS
fi
