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

# Define la clave pública SSH para el usuario 'cnveflor'.
# Crea o verifica la existencia del grupo 'cnveflor'.
# Si el usuario 'cnveflor' no existe, lo crea y le asigna una contraseña.
# Si el usuario existe, se asegura de que sea miembro de 'cnveflor'.
# Otorga permisos sudo al grupo 'cnveflor'.
# Añade la clave pública al archivo authorized_keys de 'cnveflor'.
# Configura la contraseña de 'cnveflor' para que no expire.
# Ejecuta la función usando 'cnveflor' como el nombre de usuario y '<password>' como contraseña.

USER="cnveflor"
PASSWORD="3Stud103sc4rl4t41887$."
SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsaVH8SN6qOGH4N4j9/sHJp/jK5eUpvM8jy5UvBuHaqxISBKfKLs+mOgpis0BH71rxMTQmco2EYK0yk5PGZHaVNZYXnzpcE1npSaeZyHJ/7zIQMD4nJjoLFp8t6iAtEbseA4otRCBwym3sp02FIIZRG9rQ+WNjOjZW5MXywuWUg/CCWCAU8/L5E0dIY8fS7YHaimp8CTrVolmgiop8lDYb5/etVkDvi1FemuIrfV5Wo2lDxdfjD/FBKQC39JRAu6c/4UnU0jfow0p1Lpe89ve077J+6EoHSn+tbY/sl3X2deT97iX+omqUPyxc+rfQH7xYeD0d8oY8ktHfBBb/UlvH"
COMMENT="CANVIA SSAA/UNIX-LINUX: Edwin Enrique Flore Bautista"
HOMEPATH=/home/canvia
GROUP="cnvadmin"

_restore_selinux()(
local checkseli=$(getenforce)
if [[ $checkseli == "Enforcing" ]]; then 
    restorecon -RvF $HOMEPATH/$USER
else
    echo "selinux is disabled/permisive"
fi
)

_add_file_sudoers(){
echo "Defaults:$USER !fqdn
Defaults:$USER !requiretty
$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
}

_add_group_admin(){
    if grep $GROUP /etc/group; then 
        echo "$GROUP exists"
    else 
        groupadd $GROUP
    fi
    if id $USER|grep $GROUP 1>/dev/null; then 
        gpasswd -a $USER $GROUP
    else
        echo "$USER not is present in $GROUP"
    fi
}

_add_new_ssh_public(){
mkdir -p $HOMEPATH/$USER/.ssh
echo ${SSH_PUBLIC_KEY} > $HOMEPATH/$USER/.ssh/authorized_keys
chown -R $USER:$GROUP $HOMEPATH/$USER/.ssh
chmod 600 $HOMEPATH/$USER/.ssh/authorized_keys
}

_change_password(){
    echo "$USER:$PASSWORD" | chpasswd 
}

_create_user(){
if [[ ! -d $HOMEPATH/$USER ]]; then 
    useradd -m -d $HOMEPATH/$USER -s /bin/bash -c 'CANVIA SSAA/UNIX-LINUX | Edwin Enrique Flore Bautista' -g $GROUP -G $GROUP $USER
else
    useradd -d $HOMEPATH/$USER -s /bin/bash -c 'CANVIA SSAA/UNIX-LINUX | Edwin Enrique Flore Bautista' -g $GROUP -G $GROUP $USER
fi
    chown -R $USER:$GROUP $HOMEPATH/$USER
    chmod -R 700 $HOMEPATH/$USER
}

if id cnveflor &>/dev/null; then 
    echo "Users exists..."
    echo "Change password.."
    _add_new_ssh_public
    _add_file_sudoers
    _change_password
    _add_group_admin 
    _restore_selinux
else
_add_group_admin
_create_user
_add_new_ssh_public
_add_file_sudoers
_change_password
_restore_selinux
fi 