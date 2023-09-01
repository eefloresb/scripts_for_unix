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

# Script que te permite configurar el repositorio de un satellite remoto para el ugprade de 
# Servidores Linux

#Assigned Values 
package_katello="katello-ca-consumer-latest.noarch.rpm"
rhsm_baseurl="https://lprhsatellite.lapositiva.com.pe/pub/"
enable_activationkey="RHEL-7-PRD"
packages_rhs="katello-host-tools, katello-host-tools-tracer, katello-agent"
clientreg="Canvia"
OS=$(uname)
SUSE_REL_FILE="/etc/SuSE-release"
RH_REL_FILE="/etc/redhat-release"
DEBIAN__REL_FILE="/etc/debian_version"
OS_FILE="/etc/os-release"

export PATH=$PATH:/usr/sbin:/sbin

__oslevel__(){
  if [ $OS = "Linux" ]
  then
    if [ -f $OS_FILE ]
    then
      DISTRO=$(grep -w ID $OS_FILE | cut -d = -f 2 | tr -d '"' | tr a-z A-Z)
      LEVEL=$(grep -w VERSION_ID $OS_FILE | cut -d = -f 2 | tr -d '"')
      echo -n "$DISTRO $LEVEL"
    elif [ -f $SUSE_REL_FILE ]
    then
      if grep -qi "enterprise" $SUSE_REL_FILE
      then
        DISTRO="SLES"
      elif grep -qi "opensuse" $SUSE_REL_FILE
      then
        DISTRO="OPENSUSE"
      fi
      LEVEL=$(grep "^VERSION.*=" $SUSE_REL_FILE | cut -d = -f 2 | tr -d ' ')
      echo -n "$DISTRO $LEVEL"
    elif [ -f $RH_REL_FILE ]
    then
      if grep -qi "red.*hat.*enterprise" $RH_REL_FILE
      then
        DISTRO="RHEL"
      elif grep -qi "centos" $RH_REL_FILE
      then
        DISTRO="CENTOS"
      fi
      LEVEL=$(grep -oE '([[:digit:]]\.?)+' $RH_REL_FILE)
      echo -n "$DISTRO $LEVEL"
    elif [ -f $DEBIAN_REL_FILE ]
    then
      LEVEL=$(grep -oE '([[:digit:]]\.?)+' $DEBIAN_REL_FILE)
      if [ -n "$LEVEL" ]
      then
        DISTRO="DEBIAN"
      else
        if which lsb_release > /dev/null 2>&1
        then
          DISTRO="UBUNTU"
          LEVEL=$(lsb_release -sd  | grep -oE '([[:digit:]]\.?)+')
        fi
      fi
      echo -n "$DISTRO $LEVEL"
    fi
  fi  
}

__update_packages__(){
    local os=$1
    if [[ $os == "RHEL" ]] || [[ $os == "CENTOS" ]]; then 
        yum update all -y 
    elif [[ $os == "DEBIAN" ]] || [[ $os == "UBUNTU" ]]; then 
        apt update -y 
    elif [[ $os == "SLES" ]]; then 
        zypper update ; zypper upgrade -y
    else
        echo "SO no reconocido"
    fi
}

__install_katello(){
    local band=false
    # Installed package katello repo  
    if [[ ! $(rpm -qa katello) == "katello.*rpm" ]]; then 
        yum install $package_katello -y
        # Installed package software to katello 
        IFS=","
        for i in $packages_rhs; do 
            yum install $i -y 
        done
        band="true"
    fi
    echo $band
}

__check_subscription(){
    # check suscription 
    COMAND=$(subscription-manager list |grep -iE ^status\:[[:blank:]]+|tr -d " " | awk -F ":" '{print $2}')
    if [[ $COMAND == "Not Registered" ]] || [[ $COMAND == "Unknown" ]] || [[ $COMAND == "NotSubscribed" ]]; then 
        subscription-manager register --org="$clientreg" --activationkey="$enable_activationkey"
    else
        echo "the suscritpion server is completed..."
    fi    
}
__configure__(){
    band=$(__install_katello)
    if [[ $band == "true" ]]; then 
        __check_subscription
        echo "Desea continuar: "
        read input
        case($input) in 
            "yes")
                __update_packages__;;
            "no") exit 0;;
            *) ;;
        esac
    else 
        echo "The error is detected, check DNS and ports with redhat satellite"
    fi
}

__main__(){
    local DISTRO
     
    if [[ $band == "RedHat" ]]; then 
        __configure__
    else
        __update_packages__
    fi    
}

__main__