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

# Reporte de procesos que están almacenados en memoria swap.
PSARG="-p"
TOP="10"
[ -z "$1" ] || TOP=$1
grep VmSwap /proc/[0-9]*/status 2> /dev/null | sort -n -k 2 -r | awk '{ print $1,$2 }' | head -n $TOP |
while read arg1 mem
do
  pid=$(echo $arg1 | cut -d / -f 3)
  process=$(ps $PSARG $pid -o comm | tail -n +2)
  mem=$(echo "scale=2;$mem/1024"|bc)
  echo $pid $process $mem Mb
done
