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

# Conecta L1(127.0.0.1)==>s2(192.168.10.10)==>s3(10.10.10.10)
# No soporta clave trasmitida por ssh-pass
# Version: 12/11/2023 
# email: eflores@sfi-networks.com
# El archivo debe almacenarce /scripts/ con permisos 755
#
L1IP="127.0.0.1"
PORT1="9090"
S2IP="192.168.10.10"
xKey2="/private/keys/keys2.id_rsa"
S3IP="10.10.10.10"
S3PORT="22"
xKey3="/private/keys/keys3.id_rsa"

mi_script(){
######### Defines los comandos a enviar
echo "Hola desde mi función"
exit 0
}

active_tunneling_remote(){
  ssh -NL 9090:${S3IP}:${S3PORT} -i /private/keys/keys2.id_rsa ${S2IP} &>/dev/null & 
}
active_tunneling_remote
connect_local_remote_tunneling(){
 ssh @${L1IP} -p${PORT1} bash -s < ${mi_script}
}

connect_local_remote_tunneling

# Esto lo puedes complementar con cron; cada 30 minutos los domingos y viernes 
*/30 * * * 0,5 /scripts/./remote_ssh_tunneling.sh
