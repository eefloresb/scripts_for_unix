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

RUTA="/aasap_2/archivelog_2"
MAILFROM="sysadmin@canvia.com"
RUTASCRIPT="/bkp_arch/backup_archives_delete.sh"
MAILTO="eflores@canvia.com"
WARNING='(90%|91%|92%|93%|94%)'
LOGhora="/tmp/monitoreo_oracle.html"
SUBJECT="Send mail alert AASAl2"

__job(){
 JOB=$(ps -fea|grep backup_archive_delete.sh|grep -v grep | wc -l|tr -d " ")
 echo $JOB
}

__script(){
 $RUTASCRIPT
 echo "" > /tmp/lock,.run
}

__send_mail(){
sendmail -t << EOF
FROM: $MAILFROM
TO: $MAILTO
SUBJECT: $SUBJECT
$(cat $LOGhora)
EOF
}
__body(){
check_job=$1
echo '<html>' > $LOGhora
echo '<h1 align="center"><font color="#4188b2" face="Arial" size="3" align="center"><b>REPORTE DE ROTACIONES - $HOSTNAME </b></font></h1>' >> $LOGhora
echo '<h1 align="center"><font face="Arial" size="2" align="center"><b>El Proceso esta corriendo en $check_job</b></font></h1>' >> $LOGhora
}

__alert(){
local RUTA=$1
  if [[ $RUTA == "/aasap_2/archivelog_2" ]]; then
      check_job=$(__job)
      echo $check_job
      band=$(cat /tmp/lock.run)
      echo $band
       if [[ ${check_job} == "0" && $band == "" ]]; then
         echo "1" > /tmp/lock.run
         __script
         __body $check_job
         __send_mail
       else
         if [[ $band == "1" && ${check_job} == "0" ]]; then
           echo "" > /tmp/lock.run
         fi
       fi
  else
    echo ""
  fi
}

__xCheckFilesystem(){
local RUTA=$1
IFS=":"
COMMAND=$(df -gP | grep -i "%"| grep $RUTA)
xValorMin=$(echo $COMMAND |grep -iE $WARNING |awk '{print $5}' | tr -d "%")

if [[ -z $xValorMin ]]; then
echo "" > /tmp/lock.run
else
    __alert $RUTA
fi
}
while true; do
 IFS=":"
 for i in $RUTA; do
   xRUTA=$i
   __xCheckFilesystem $xRUTA
   sleep 1
 done
done

