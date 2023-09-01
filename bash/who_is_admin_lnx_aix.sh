rm /tmp/usuarios.txt 2>/dev/null 
rm /tmp/users.txt 2>/dev/null 
ipaddr=$(ifconfig -a | grep -w inet | awk '{print $2}'|grep -v 127.0.0.1 |head -n 1)
xhostname=$(hostname)
osname=$(uname) 
osystemf=$(
if [[ $osname == "Linux" ]]
then 
    if [[ -f /etc/os-release ]]
    then
          os=`grep -w "ID" /etc/os-release | awk -F = '{print $2}' | tr -d '"'`
          if [[ $os == "centos" ]] || [[ $os == "RedHat" ]]
          then
               echo  RedHat 
          elif [[ $os == "Debian" ]] || [[ $os == "Ubuntu" ]]
          then
               echo Debian
          elif [[ $os == "sles" ]]
          then 
            echo Suse
          fi
     elif [[ -f /etc/redhat-release ]]
     then
          os=$(grep -ow "Red Hat" /etc/redhat-release)
          if [[ $os == "Red Hat" ]]
          then
               echo RedHat
          fi       
     elif [[ -f /etc/SuSE-release ]]
     then 
            echo Suse
     fi
elif [[ $osname == "AIX" ]] 
then
    echo $osname
elif [[ $osname == "SunOS" ]]
then
    echo $osname
fi
)
ossystemv=$(
if [[ $osname == "Linux" ]]
then
    if [[ -f /etc/redhat-release ]]; then 
        os=$(grep -ow "Red Hat" /etc/redhat-release) 
    elif [[ -f /etc/os-release ]]; then 
        os=$(cat /etc/os-release | grep -i "^name="|awk -F= '{print $2}'|tr -d '"')
    fi
    if [[ $os == "Red Hat" ]]; then 
        version=`grep -Ewo '[[:digit:]]\.[[:digit:]]' /etc/redhat-release`
    elif [[ $os == "SLES" ]] || [[ $os=="Ubuntu" ]] || [[ $os == "Debian" ]]; then
        version=`grep -w "VERSION_ID" /etc/os-release | awk -F = '{print $2}' | tr -d '"'`
    fi
elif [[ $osname == "AIX" ]]
then 
    versiona=$(uname -a|awk '{print $4}')
    versionb=$(uname -a|awk '{print $3}')
    version="$versiona.$versionb"
elif [[ $osname == "SunOS" ]]
then 
    version=$(cat /etc/os-release|grep -i "version=" | awk -F= '{print $2}')
fi
echo $version
)
if [[ ${ossystemv%\.*} == "5" ]]
then 
    i=0;
    j=0;
else 
    declare -a xUser;
    declare -i i=0;
    declare -i j;
fi
cat /etc/passwd|awk -F: '{print $1}' | while read user; do  sudo -l -U $user 2>/dev/null; done |egrep -e "(ALL$|may run|su - root)" >> /tmp/users.txt
LOGTMP="/tmp/users.txt"
while read line; do
    xUser[$i]="$line"
    i=$i+1
done < $LOGTMP

_return_description(){
    local xUser=$1
    local xDescription=$(cat /etc/passwd |grep $xUser | awk -F ":" '{print $5}')
    echo $xDescription | tr -d ","
}

#User psgmdlpr may run the following commands on this host:
#    (root) NOPASSWD: ALL
#User cnvrgara may run the following commands on SMPPRDBD:
#    (ALL) NOPASSWD: ALL
_select_data(){
    for (( j=1; j<${#xUser[@]}; j++ )); do
        if echo ${xUser[$j-1]} | grep "may run" 1>/dev/null; then
            $(echo ${xUser[$j]} | egrep -e "(ALL|root).*ALL" 1>/dev/null)
            valor=$(echo $?)
            if [[ $valor -eq 0 ]]; then 
                local xUsuario=$(echo ${xUser[$j-1]} | awk '{print $2}')                
                local xDescription=$(_return_description $xUsuario)
                echo "$ipaddr,$xhostname,$osystemf,$ossystemv,$xUsuario,$xDescription" >> /tmp/usuarios.txt
            fi 
        fi
    done
    if [[ $osname == "Linux" ]]; then 
        sed -rie "s/:$//g" /tmp/usuarios.txt
    elif [[ $osname == "AIX" ]]; then 
        sed -e "s/:$//g" /tmp/usuarios.txt > /tmp/usuarios_new.txt 
        cat /tmp/usuarios_new.txt > /tmp/usuarios.txt
    fi
cat /tmp/usuarios.txt
}

_select_data
