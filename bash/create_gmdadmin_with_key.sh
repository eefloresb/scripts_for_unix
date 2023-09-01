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

# Define la clave pública SSH para el usuario 'gmdadmin'.
# Crea o verifica la existencia del grupo 'gmdadmin'.
# Si el usuario 'gmdadmin' no existe, lo crea y le asigna una contraseña.
# Si el usuario existe, se asegura de que sea miembro de 'gmdadmin'.
# Otorga permisos sudo al grupo 'gmdadmin'.
# Añade la clave pública al archivo authorized_keys de 'gmdadmin'.
# Configura la contraseña de 'gmdadmin' para que no expire.
# Ejecuta la función usando 'gmdadmin' como el nombre de usuario y '<password>' como contraseña.

PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3jgTxFRL4cYjY6PDm1WOeVUcC9b27NPlaKx8OF4QNuTNQ7eUphFEwWlyXc0Bx2ziDgnLgbb1FFaRHOX3zgZE/ihvZn6FS/CPixdsgBlGsDX+uZGp1vsQtYXQKE4e8Ihv5V6/Kop6FmRsxrm0lZgCihWECzkbBUa2GXyHiDj2eZDtrojpdMqWgZzryUI3cTAF004oa1GpqkUsideAN/PUQi3AzJz5l13SFhfewI6ErkBibMD+bjmkIiKDuxWAXh68nyr1ciWXnKklTFl+3PS7GDs8SBmy8xY0wu6i++jaQk6+ikgGfeBHEUHvwP+cxrK5nLQci+hkmYULgXTOqgfkP gmdadmin@pivot.canvia.com"
_xcreate_usuer_canvia(){
  local USER=$1
  local PASSWORD=$2

      if ! grep -q cnvadmin /etc/group; then 
        groupadd cnvadmin
      fi
      
      if ! grep -q $USER /etc/passwd; then 
        useradd -m -d /home/$USER -s /bin/bash -g users -G users,cnvadmin -c "CANVIA SSAA/Unix - Linux - Admin. $USER" $USER
        echo -e "$USER:$PASSWORD" | chpasswd
      else
        if ! id $USER |grep -q cnvadmin; then
          gpasswd -a $USER cnvadmin
        fi
      fi
  
      ####### Declare function to group in sudoers 
      if ! grep -Eq "^%cnvadmin.*" /etc/sudoers; then
        echo "%cnvadmin ALL=(ALL) ALL" >> /etc/sudoers 
      fi

      if [[ ! -d /home/cnvadmin/.ssh ]]; then
          mkdir -p /home/cnvadmin/.ssh/
      fi
      echo $PUBLIC_KEY >> /home/cnvadmin/.ssh/authorized_keys
      chage -M 99999 $USER
}

_xcreate_usuer_canvia gmdadmin GmDlnxad
