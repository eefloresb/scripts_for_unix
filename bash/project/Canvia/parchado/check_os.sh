os_system() {      
 if [ -f /etc/redhat-release ]; then
    if grep -qEiwo "red[[:blank:]]+hat" /etc/redhat-release; then
        ansible_distribution="RedHat"
    fi
 elif [ -f /etc/centos-release ]; then 
    if grep -qEiwo "centos[[:blank:]]*(stream)*" /etc/centos-release; then
        ansible_distribution="CentOS"
    fi
 elif [ -f /etc/os-release ]; then 
    . /etc/os-release
     case $ID in
         ubuntu)
             ansible_distribution="Ubuntu"
             ;;
         debian)
             ansible_distribution="Debian"
            ;;
         ol)
             ansible_distribution="ol"
             ;;
         sles)
             ansible_distribution="SLES"
             ;;
         sles_sap)
             ansible_distribution="SLES-SAP"
         ;;
         *)
             echo "Distribución no soportada."
             return 99
             ;;
     esac
 else
     echo "Distribución no detectada o no soportada."
 fi
}