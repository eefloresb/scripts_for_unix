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

# Crea un script automatizado que te permite copiar en n servidores, el contenido
# realiza la eliminación del fichero con nombre qf25f5 como prefijo a continuación 
# todo lo demás

# cron..
# 0 0 * * * /scripts/./delete_files_qf25f5.sh 
mkdir -p /scripts
cat >> /scripts/./delete_files_qf25f5.sh < EOF
#!/bin/bash
REMOTEDIR="/var/spool/clientmqueue"
cd $REMOTEDIR
find . -mtime 0 -type file -iname "qf25f5*" -exec rm -r {} \;
EOF 

