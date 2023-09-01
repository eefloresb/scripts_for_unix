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

# Detener un proceso con nombre aide a nivel del SO se requiere ser root
# Contar los procesos en ejecución que contienen la palabra "aide", excluyendo los que contienen "grep".
count=$(ps -fea|grep aide|grep -v grep | wc -l)
# Verificar si hay procesos "aide" en ejecución.
if [[ $count -gt "0" ]]; then
  # Listar los PIDs de los procesos "aide".
  ps -fea |grep aide | grep -v grep | awk '{print $2}' | while read line; do
    # Finalizar (matar) forzadamente cada proceso "aide" encontrado.
    kill -s 9 $line;
   done
fi
