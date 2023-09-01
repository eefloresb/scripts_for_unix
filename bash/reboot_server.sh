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

os=$(uname)
USER=$(who a mi)
SHELL=$(echo $0)
DATE=$(date +%Y-%m-%d)
if [[ ! -d /var/log/history ]]; then
  mkdir -p /home/$USER/logs/
  USERLOGS="/home/$USER/logs/"
fi
_write_log(){
  if [[ ! -z $USERLOGS ]]; then 
        echo "Shutdown reboot now for $os" >> /home/$USER/logs/history_reboot
        echo "$USER:$SHELL in $(hostname) with $DATE" >> /var/log/history_reboot              
  fi
}
_reboot_os(){
  _write_log
  if [[ $os == "Linux" ]] || [[ $os == "AIX" ]]; then
      sudo shutdown -r now
  else [[ $os == "SunOS" ]]; then
    sudo shutdown -i6 -g 60 -y
  fi
}
_reboot_os

