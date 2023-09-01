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

# Script que me permite validar si en el host remoto está configurado
# el servicio de internet, útil en un reporte con el cual puedes obtener 
# datos de que puede estar fallando.
_dns_resolv(){
    server=$1
    if host -t A redhat.com $server &>/dev/null; then
        echo "OK"
    else
        echo "Failed"
    fi
}

_name_server(){
    if cat /etc/resolv.conf|grep nameserver &>/dev/null; then
      for i in `grep -E "^nameserver[[:blank:]]+" /etc/resolv.conf | awk '{print $2}'`; do
        OK=$(_dns_resolv $i)
        if [[ $OK == "OK" ]]; then
            echo "Sucess" 
	    break
        fi
       done
    else
        echo "Failed"
    fi
}

# Validar url genera 2 valores Sucess/Failed
_check_download_packages(){
    if curl -I https://www.redhat.com/en &>/dev/null; then
        echo "Sucess"
    else
        echo "Failed"
    fi
}

_check_return_value(){
    xdns=$(_name_server)
    xweb=$(_check_download_packages)
    if [[ $xdns == $xweb ]]; then
        echo "Sucess"
    else
	      echo "Failed"
    fi
}
