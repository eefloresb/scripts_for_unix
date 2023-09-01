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

# Validar si el puerto del servicio ssh está activo para ello se ejecuta nmap a un conjunto de servidores
# almacenados en el fichero list_ips
_xnmap(){
  line=$1
  echo $line >> results.txt
  nmap -p22 $line | grep -E "(Host is up|22/tcp open)" >> results.txt
}

while read line; do
  returnvalue=$(_xnmap $line)
done < list_ips
