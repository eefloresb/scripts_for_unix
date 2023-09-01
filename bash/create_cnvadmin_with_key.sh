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

# Define la clave pública SSH para el usuario 'cnvadmin'.
# Crea o verifica la existencia del grupo 'cnvadmin'.
# Si el usuario 'cnvadmin' no existe, lo crea y le asigna una contraseña.
# Si el usuario existe, se asegura de que sea miembro de 'cnvadmin'.
# Otorga permisos sudo al grupo 'cnvadmin'.
# Añade la clave pública al archivo authorized_keys de 'cnvadmin'.
# Configura la contraseña de 'cnvadmin' para que no expire.
# Ejecuta la función usando 'cnvadmin' como el nombre de usuario y '<password>' como contraseña.

PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcpTUDH/RYsWztlzxeiu1JAzpwq6sc9OFuczttWSiJZM8ZlaRlU+YXly6ukfV4Gsfd22P9y4Qlt5HuzWi9aTXmucOzpcKWJmKalxXkl/2+iUX6UsLgLqc6tKG7CUoV1oDKpDfKoT59W2pLYvvsLIlu+07IxnTxVG9An8xnnNvIkA6GEx31FRp/X+GUVVSNjkjeNYGZCLexb45zonGXVW0M9iABmsU8hZNih2ONyNNmnfGS3TAghi+I39V0P8R+tPVqhsePf8iji0HUJnEBkOMbcKTqHIbCUDoQtcJwFLhzm4VlzvakZhDe9oI6smi6wpybO5Zj5tB9UXfYLwUhA1ID cnvadmin@lnxbastion.canvia.com"
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

_xcreate_usuer_canvia cnvadmin CnVlnxad