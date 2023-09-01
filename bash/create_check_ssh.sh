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

# Script que te permite validar si en el servidor remoto 172.30.10.37 se puede ejecutar un comando
while true; do 
  if ssh -i ~/.ssh/pivot_rsa gmdadmin@172.30.10.37 "echo hola mundo; exit 0"; then
    echo "connected ... with time ... 2 seconds"
  else 
    echo "failed connection to remote server"
  fi
done
