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

COMMAND="netstat -Aan -f inet | grep -i listen"
_xProgram(){
declare -i PROCCESSID=$1
PROGRAM=$(ps -fea|grep $PID | grep -v grep | awk '$9')
echo $PROGRAM
}
_xProccess(){
netstat -Aan -f inet | grep -i listen | while read line; do
  PROCCESSID=$(echo $line |awk '{print $1}')
  PROTOCOL=$(echo $line |awk '{print $2}')
  PORT=$(echo $line |awk '{print $5}')
  STATE=$(echo $line |awk '{print $7}')
  if [[ $STATE != 'LISTEN' ]]; then
  STATE=$(echo $line |awk '{print $8}')
  fi
  #echo $PROCCESSID","$PROTOCOL","$PORT","$STATE
done
}
_xProccess
