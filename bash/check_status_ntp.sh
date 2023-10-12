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

# valida el funcionamiento del servicio de tiempo en un servidor remoto
myfunction() {
 
 if which ntp 2>/dev/null; then 
     sudo ntpq -n -p 
 else 
     sudo chronyc tracking 
 fi
}
$SSH $IP "export PATH=\$PATH:/sbin:/usr/sbin ; $(typeset -f myfunction); myfunction" 2> /dev/null > $result
