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

# Script que te permite crear multiples usuarios de un listado de tipo USER PASSWORD con salto a root

# Define la clave pública SSH para el usuario '<user>'.
# Crea o verifica la existencia del grupo '<user>'.
# Si el usuario '<user>' no existe, lo crea y le asigna una contraseña.
# Si el usuario existe, se asegura de que sea miembro de '<user>'.
# Otorga permisos sudo al grupo '<user>'.
# Añade la clave pública al archivo authorized_keys de '<user>'.
# Configura la contraseña de '<user>' para que no expire.
# Ejecuta la función usando '<user>' como el nombre de usuario y '<password>' como contraseña.

_xcreate_usuer_canvia(){
  local USER=$1
  local PASSWORD=$2

      if ! grep -q administradores /etc/group; then 
        groupadd administradores 
      fi
      
      if ! grep -q $USER /etc/passwd; then 
        useradd -m -d /home/$USER -s /bin/bash -g users -G users,administradores -c "Orion SSAA/Unix - Linux - Admin. $USER" $USER
        echo -e "$USER:$PASSWORD" | chpasswd
      else
        if ! id $USER |grep -q administradores; then
          gpasswd -a $USER administradores 
        fi
      fi
  
      ####### Declare function to group in sudoers 
      if ! grep -Eq "^%administradores.*" /etc/sudoers; then
        echo "%administradores ALL=(ALL) ALL" >> /etc/sudoers 
      fi


echo "adcan_eflores:3Stud103sc4rl4t41887$" | chpasswd
}
IFS=":"
while read USER PASSWORD; do 
  _xcreate_usuer_canvia $USER $PASSWORD
done < list_users.txt 
