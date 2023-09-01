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

# El código es un script de bash que está diseñado para copiar archivos de log del directorio /usr/sap/PRD/D02/log/ de una máquina local a otro servidor remoto en la ubicación /usr/local/saplogs/logs.

USER=logsap
REMOTE=172.16.2.79
PRIVATEKEY="/home/logsap/.ssh/id_rsa"
ROUTEORIGEN="/usr/sap/PRD/D02/log/"
ROUTEDEST="/usr/local/saplogs/logs"
COMMAND="scp -P22 -r"
LOGEND="/var/log/endfilelog.cp"
TMP=/tmp/temp 
mkdir -r /tmp/temp 
cd $ROUTEORIGEN
if [[ ! -f $LOGEND ]]; do 
  touch $LOGEND 
    ls -C1 audit* | 
      while read line; do 
        gzip -c $line > /tmp/
        if $COMMAND $line $ROUTEDEST; then 
          echo COPYP:$REMOTE:$line:OK >>  
        fi
      done
    done
  done
else

fi

