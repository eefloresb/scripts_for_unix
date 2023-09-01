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

# Gestiona máquinas virtuales con Vagrant

_up_vagrant_machine(){
OS=${2:-redhat}
UPLOAD=$(~/data/./myscript.sh $OS)
USERACCOUNT=$UPLOAD vagrant up 
}

_halt_vagrant_machine(){
vagrant halt 
}

_provision_vagrant_machine(){
if [ ! -z $OS ]; then 
  UPLOAD=$(~/data/./myscript.sh $OS)
  USERACCOUNT=$UPLOAD vagrant provision --provision-with shell
else
  vagrant provision --provision-with ansible
fi
}


case $1 in 
  "UP")
    _up_vagrant_machine
    ;;
  "STOP")
    _halt_vagrant_machine 
    ;;
  "PROVISION")
    _provision_vagrant_machine
    ;;
  *)
    "Input start with up/stop/provision, all capital letter"
    ;;
esac
