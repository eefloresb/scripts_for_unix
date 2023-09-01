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

# Configurar el servicio Qradar a nivel del servicio rsyslog.conf 
# Esta configuración es realizada para el cliente de UNICON
_x_Restart_service(){
DAEMON="/etc/init.d/rsyslog"
if [[ ! -f $DAEMON ]]; then 
  systemctl restart rsyslog 
else  
  $DAEMON stop
  $DAEMON start
fi 

}

if [[ -f /etc/rsyslog.conf ]]; then 
    if grep "@10.22.10.107" /etc/rsyslog.conf; then
      echo "Siem Assigned to log collector"
    else
      echo "*.* @10.22.10.107" >> /etc/rsyslog.conf
      _x_Restart_service
    fi
fi
