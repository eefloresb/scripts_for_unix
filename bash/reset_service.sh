#!/bin/bash
# This soport to redhat/ubuntu to new distribution for systemctl

if which systemctl 2>/dev/null; then
    PROGRAM=$(which systemctl)
elif which service 2>/dev/null; then
    PROGRAM=$(which service)
else
    echo "the daemon service not exists, you write mail to eflores@canvia.com"
fi

# Lista de servicios a reiniciar
declare -a SERVICIOS
declare -i i=0
while read line; do
    SERVICIOS[$i]="$line"
    i=$i+1
done < /etc/services-restart-cecom

__all_reset_services(){
# Iteramos sobre la lista de servicios y los reiniciamos uno por uno
for servicio in "${SERVICIOS[@]}"
do
  servicio=$(echo $servicio | awk -F ":" '{print $2}')
  sudo $PROGRAM restart "$servicio"
done
echo "Se han reiniciado los servicios: ${SERVICIOS[*]}"
}


_get_services(){
#0x6tas0001:ds_agent:service antivirus
#0x6tas0002:pandora:service monitoring
#0x6tas0003:metricbeat:service monitoring
declare -i i=0
echo "for reset service from the menu"
echo "is write the programa o code"
echo "example ds_agent or code is 0x6tas0001"
for servicio in "${SERVICIOS[@]}"; do
    echo ${servicio} | awk -F ":" '{print $3,"-> service is ",$2," (","code error is",$1,")"}'
    i=$i+1
done
}

_find_service_code_return(){
name=$1
declare -i i=0
for servicio in ${SERVICIOS[@]}; do
    if echo $servicio | grep -qwo $name; then
        echo $servicio | awk -F ":" '{print $2}'
    else
        echo "xerror"
    fi
done
}

_reset_by_service_code(){
service_name=$(_find_service_code_return $1)
 if [[ ! ${service_name} == "xerror" ]]; then
    if sudo $PROGRAM restart $service_name; then
        echo "restart ... $service_name"
    else
        sudo $PROGRAM stop $service_name
        sudo $PROGRAM start $service_name
    fi
 else
    echo "$service_name in $1"
 fi
}

_stop_by_service_code(){
service_name=$(_find_code_return $1)
if [[ ! $service_name == "xerror" ]]; then
        sudo $PROGRAM stop $service_name
 else
    echo "$service_name in $1"
 fi
}

_start_by_service_code(){
service_name=$(_find_code_return $1)
if [[ ! $service_name == "xerror" ]]; then
        sudo $PROGRAM start $service_name
 else
    echo "$service_name in $1"
 fi
}

mostrar_menu() {
    echo "======================================="
    echo "           MENÚ PRINCIPAL              "
    echo "======================================="
    echo "1. List services for reset by code/name"
    echo "2. Reset service by code/name"
    echo "3. Reset service all into list"
    echo "4. Stop service by code/name"
    echo "5. Start service by code/name"
    echo "6. Exit"
    echo
    echo -n "Ingresa una opción [0-6]: "
}

opcion=0
while [ $opcion -ne 6 ]
do
    mostrar_menu
    read opcion
    echo
    case $opcion in
        1)
            _get_services
                ;;
        2)
            echo "Ingrese name or code"
            read name;
            _reset_by_service_code $name
                ;;
        3)
            __all_reset_services
            ;;
        4)
            echo "Saliendo del menú..."
            exit 0
            ;;
        *)
            echo "Opción inválida, intenta de nuevo."
            ;;
    esac
    echo
done