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

#Este script parece estar diseñado para comparar listas de paquetes (tal vez paquetes de software o dependencias) entre varias distribuciones de Linux y decidir qué paquetes son específicos para ciertas distribuciones y cuáles son genéricos. 
function __generic(){
  cat ./genericrhel.txt | 
  while read line; do 
    if [[ $(grep -w "${line}" ./debian) && $(grep -w "${line}" ./sles) && $(grep -w "${line}" ./amazon2) ]]; then 
      echo ${line} >> generic2.txt
    fi 
  done
}
function __rhel6(){
  cat ./rhel6 | 
    while read line; do 
      ### se repite al menos en 1 
      if [[ ($(grep -w ${line} ./rhel7) || $(grep -w ${line} ./rhel8)) && ! $(grep -w ${line} ./generic.txt) ]]; then 
        echo ${line} >> rhel6ng
      fi
    done
}

function __rhel7(){
  cat ./rhel7 | 
    while read line; do 
      ### se repite al menos en 1 
        if [[ ! $(grep -w ${line} ./generic.txt) ]]; then
          echo ${line} >> rhel7ng
        fi
    done
}

function __rhel8(){
  cat ./rhel8 | 
    while read line; do 
      ### se repite al menos en 1 
        if [[ ! $(grep -w ${line} ./generic.txt) ]]; then
          echo ${line} >> rhel8ng
        fi
    done
}

function __sles(){
  cat ./sles | 
    while read line; do 
      ### se repite al menos en 1 
        if [[ ! $(grep -w ${line} ./generic2.txt) ]]; then
          echo ${line} >> slesng
        fi
    done
}

function __debian(){
  cat ./debian | 
    while read line; do 
      ### se repite al menos en 1 
        if [[ ! $(grep -w ${line} ./generic2.txt) ]]; then
          echo ${line} >> debiang
        fi
    done
}

#where is generic file the all similar packages to rhel 6/7/8
function __amazon(){
  cat ./amazon1 | 
    while read line; do 
      ### se repite al menos en 1 
      if [[ ! $(grep -w ${line} ./generic2.txt) && ! $(grep -w ${line} ./generic.txt) ]]; then
              if grep -qw ${line} ./amazon2; then 
                    echo ${line} >> amazon_generic
              else
                    echo ${line} >> amazon1ng
              fi
      fi
    done
}
__amazon
