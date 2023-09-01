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

# Valida que usuario procedio con el reinicio del servidor
xlastlog{
 last | grep -Ei "(reboot|shutdown)" | head -n3
} 

_xbusquedalog(){
declare -a vector
if which ausearch; then 
    ausearch -i -m system_boot,system_shutdown | grep -v "\-\-\-" | head -n1 | grep --color -Ewo "(pid\=[[:digit:]]+|uid=root|[0-9][0-9]/[0-9][0-9]/202[0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9])" | while read line; do 
        vector+=($line)
    done
fi
}
