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

# Script que se integra con Vagrant para poder configurar las subscripciones a nivel del SO
# útil para los servidores de prueba, vagrant es usado como infraestructura como código
PASSWDTXT="~/data/passwd.txt"
if [[ $1 == "unregister" ]]; then
UNREGISTER="OK"
_check_distro 
fi

if [[ -f /tmp/passwd.txt ]]; then 
FILE=$PASSWDTXT
fi

_root_user(){
USERLOCAL="root"
PASSWDLOCAL="password"
echo "$USERLOCAL:$PASSWDLOCAL" | chpasswd 
}

      _get_repo_cen5(){
###### remove old repos from yum.repos.d 
mv -v /etc/yum.repos.d/*.repo /tmp 
cat >> /etc/yum.repos.d/Base.repo << EOF
#BENTO-BEGIN
[C5.11-base]
name=CentOS-5.11 - Base
#baseurl=http://vault.centos.org/5.11/os/\$basearch/
baseurl=http://archive.kernel.org/centos-vault/5.11/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1

[C5.11-updates]
name=CentOS-5.11 - Updates
#baseurl=http://vault.centos.org/5.11/updates/\$basearch/
baseurl=http://archive.kernel.org/centos-vault/5.11/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1

[C5.11-extras]
name=CentOS-5.11 - Extras
#baseurl=http://vault.centos.org/5.11/extras/\$basearch/
baseurl=http://archive.kernel.org/centos-vault/5.11/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1

[C5.11-centosplus]
name=CentOS-5.11 - Plus
#baseurl=http://vault.centos.org/5.11/centosplus/\$basearch/
baseurl=http://archive.kernel.org/centos-vault/5.11/centosplus/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
enabled=1
#BENTO-END
EOF
}
      _redhat_user(){
        USERS=$(cat $FILE |awk -F ":" '{print $2}')
        PASSWDS=$(cat $FILE |awk -F ":" '{print $3}')
      }

      _sles_user(){
        USERS= $(cat $FILE |awk -F ":" '{print $2}')
        PASSWDS=$(cat $FILE |awk -F ":" '{print $3}')
      }

      _registration_os_suse(){
           _sles_user
           SUSECONNECT -e $USERS -r $PASSWDS 
      }
       _deregistration_os_suset(){ 
         if [[ ! -z $UNREGISTER ]]; then 
            SUSEConnect -d
            exit
         fi
      }
      _registration_os_redhat(){
                 _redhat_user
                 subscription-manager register --username=$USERS --password=$PASSWDS --auto-attach --force 
       }
       _deregistration_os_redhat(){
            if [ `which subscription-manager` ]
            then
              subscription-manager unregister
            fi
       }
      _get_Amazon(){
          os=$1
          version=${2}
      }
      _get_Suse(){
          os=$1
          version=${2}
      }
      _get_RedHat(){
           os=$1
           version=$2
            if [[ ! -z $UNREGISTER ]]; then 
                subscription-manager unregister 
                exit 0
            fi
            if which subscription-manager &>/dev/null; then 
                if [ `subscription-manager status | grep Overall | cut -d : -f 2 | tr -d " "` == "Unknown" ]
                then
                    _registration_os_redhat
                fi
           fi
           ### Desactiva repositorio epel para oracle
           if [ $os = "Oracle" ]; then
                sed -i -e "/enabled/s/1/0/" /etc/yum.repos.d/epel.repo
           else  
               if [[ $version -ge 8 ]]; then
                    dnf install -y python36
                    ln -s -f /usr/libexec/platform-python3.6 /usr/bin/python
               elif [[ $version -eq 7 ]]; then
                    echo -e "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/environment
               elif [[ $version -eq 6 ]]; then
                    yum install -y libselinux-python --nogpgcheck
               elif [[ $version -eq 5 ]]; then
                    ln -s -f /usr/share/zoneinfo/America/Lima /etc/localtime
                    if [ $(grep -woi centos /etc/redhat-release) ]; then 
                      _get_repo_cen5
                    fi
                    yum install -y epel-release --nogpgcheck
                    yum install -y python26 --nogpgcheck
               fi
           fi

      }

      _get_Debian(){
           os=$1
           version=$2
           apt-get update
           if [ $os == "ubuntu" ] && [ ${version%%.*} -le 16 ]
           then
            export DEBIAN_FRONTEND=noninteractive
            apt-get install -y python
           fi
      }

      _check_distro(){
           _root_user
           if [ -f /etc/redhat-release ]
           then
              if [[ $(grep -owi "Red Hat" /etc/redhat-release) == "Red Hat" ]]
              then
                        os="RedHat"
              elif [[ $(grep -woi CentOS /etc/redhat-release) ]]
              then
                         os="CentOS"
              fi
              version=`grep -woE '[[:digit:]].*' /etc/redhat-release | cut -d "." -f1`
              _get_RedHat $os $version
           elif [ -f /etc/oracle-release ]
           then
              os=$(grep -Ewo "^Oracle" /etc/oracle-release)
              version=grep -Ewo '[[:digit:]]+\.[[:digit:]]+' /etc/oracle-release | cut -d "." -f1
              _get_RedHat $os $version
           elif [ -f /etc/release ]
           then
                os=`grep -woi solaris /etc/release`
                version=`grep -Ewoi [[:digit:]].[[:digit:]]+ /etc/release`
           elif [ -f /etc/os-release ]
           then
                os=`grep -w "ID" /etc/os-release | awk -F = '{print $2}' | tr -d '"'`
                version=`grep -w "VERSION_ID" /etc/os-release | awk -F = '{print $2}' | tr -d '"'`
                if [ $os == "ubuntu" ] || [ $os == "debian" ]
                then
                     _get_Debian $os $version
                elif [ $os == 'sles' ]
                then
                    _get_Suse $os $version
                elif [ $os == 'amzn' ]
                then
                    _get_Amazon $os $version
                fi
           fi
        }

_check_distro 
