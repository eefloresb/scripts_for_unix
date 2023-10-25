#!/bin/bash
## Autor: eflores@canvia.com
## Licencia: gplv2
## /tmp/Solicitud_20100210909_20221207_01.txt
### SOPORTE DESARROLLO ###
## file1.TXT
## file2.TXT
## file3.TXT
## /tmp/Solicitud_20100210909_20221207_01.txt
## /tmp/Solicitud_20100210909_20221207_02.txt
## /tmp/Solicitud_20100210909_20221207_03.txt

####################### Variables ############################
# Define el usuario con el que se va a conectarse al sftp
USER="sap_sftp"
GROUP="sap_sftp"
# Indica si se va a realizar una copia
COPY="copy"
# Estado inicial
STATUS="OK"
# Ruta del comando sftp
SFTP=$(which sftp)
# Sistema operativo
OS=$uname
# Dia actual
DAY=$(date +%d)
# Dia y mes actual
DAYMONTH=$(date +%d%m)
#Usuario con el que se va a conectar al sftp remoto externo
USER_REMOTE="inter_sftp"
#Password para el usuario remoto
PASSWORD_REMOTE="lapositiva123#"
#Puerto para la conexión sftp remota
PORT_REMOTE="2223"
#Servidor remoto para la conexión sftp
REMOTE_SERVER="sftp-externo"
#Directorio destino en el servidor remoto
REMOTE_DIR_DEST="/Recepcion/Solicitudes"
#Directorio destino donde se almacenara los logs
DIR_LOG=/var/log/$USER
#Ruta del archivo de backup de logs donde se almacenara el estado de los copiados al sftp externo
BACKUPLOG="/var/log/$USER/logsapcopy.log"
#Ruta del archivo de registro de copias remotas
REMOTECOPYLOG="/var/log/$USER/copyremotestatus.log"
#Nombre del host actual
HOSTNAME=$(hostname)
#Directorio origen de los archivos
RUTA_DIR_ORIGEN="/Nexus/Solicitud"
####################### End Variables ############################
#_remove_file(){
#  rFILE=$1
#  rm $rFILE
#}

__init_program(){
_create_group
_create_dir
_create_user
_create_log
}

# crear grupo sap_sftp
_create_group(){
  local check_group=$(groups $GROUP 2>/dev/null)
  if [[ -z "$(check_group)" ]]; then 
    groupadd $GROUP
  fi
}

#crear directorio /Nexus
_create_dir(){
 if [[ ! -d /Nexus ]]; then 
   mkdir /Nexus
 fi
}

#crea el usuario sap_sftp
_create_user(){
  local check_user=$(id -u $USER 2>/dev/null)
  if [[ -z "${check_user}" ]]; then 
    useradd -m -d /Nexus/Solicitud -s /bin/bash -g $GROUP -G $GROUP -c "user sap sftp" $USER
  fi
}

#crea el directorio
# _create_log() Función para crear los archivos de registro si no existen
_create_log(){
# Verificar si el directorio de log sap_sftp existe
if [[ ! -d $/var/log/$USER ]]; then 
 mkdir -p /var/log/$USER
 chown $USER:$GROUP /var/log/$USER
fi
# Verificar si el archivo de registro $BACKUPLOG existe
if [[ ! -f $BACKUPLOG ]];then
  # Crear el archivo de registro y asignar permisos
  touch $BACKUPLOG
  chown $USER:$GROUP ${BACKUPLOG}
fi
}
# Verificar si el archivo de registro $REMOTECOPYLOG existe
if [[ ! -f $REMOTECOPYLOG ]];then
# Crear el archivo de registro y asignar permisos
  touch $REMOTECOPYLOG
  chown $USER:$GROUP ${REMOTECOPYLOG}
fi

# Busca todos los archivos con el patrón "Solicitud.txt" y los guarda en el archivo de log 
_upload_data(){
local LOGTMP=$1
find * -name "Solicitud_*.txt" -prune -type f > $LOGTMP
}

#Genera un archivo temporal con un nombre aleatorio en el directorio /tmp, utiliza el comando "od" para generar números aleatorios 
#a partir del dispositivo /dev/random y luego lo usa como salida para el comando "awk" y generar así un número aleatorio de cuatro dígitos. 
#Luego se utiliza este número aleatorio para generar un nombre de archivo temporal único en el directorio /tmp.
#Después se llama a la función "_upload_data" para cargar datos en el archivo temporal y se devuelve el nombre del archivo temporal.
_generate_file_random(){
RAND=$(od -N 4 -tu /dev/random | awk 'NR==1 {print $2}')
tmpfile=/tmp/temp.${RAND}
touch $tmpfile
_upload_data $tmpfile
echo $tmpfile
}

#La función _get_data() genera un archivo temporal aleatorio utilizando /dev/random y lo almacena en la variable LOGTMP. Luego, 
#llama a la función _upload_data() para buscar archivos que coincidan con el patrón "Solicitud_*.txt" y escribirlos en el archivo 
#temporal. Finalmente, devuelve el nombre del archivo temporal generado
_get_data(){
local LOGTMP=$(_generate_file_random)
echo $LOGTMP
}

#La función _save_data_log se encarga de agregar registros al archivo de log que se especifica en la variable $BACKUPLOG. La función espera recibir 5 parámetros: $ERRPT, $BAND, $FILE, $ROUTE y $USER.
_save_data_log(){

# $ERRPT : representa el código de error que se obtiene al realizar una operación. Si el valor de $ERRPT es 0, significa que la operación 
# se realizó correctamente, 
# mientras que cualquier otro valor representa que la operación falló.
# $BAND  : indica el estado de la operación: si fue OK o FAILED esto para saber si existio una copia previa.
# $FILE  : es el nombre del archivo que se copió o se intentó copiar.
# $ROUTE : representa la ruta donde se copió o intentó copiar el archivo.
# $USER  : es el usuario que ejecutó la operación.
  local ERRPT=$1
  local BAND=$2
  local FILE=$3
  local ROUTE=$4
  local USER=$5
    if [[ "$ERRPT" == '0' ]] & [[ "$BAND" == 'OK' ]]; then
        # En caso de que la operación se haya realizado correctamente, se agrega un registro al archivo de log con el formato:
        # $ROUTE,$COPY,${FILE},$REMOTE,OK,${USER}
        echo "$ROUTE,$COPY,${FILE},$REMOTE,OK,${USER}" >> $BACKUPLOG
    elif [[ $ERRPT != '0' ]] & [[ "$BAND" == 'OK' ]]; then
          # Si la operación falló, se agrega un registro al archivo de log con el formato:
          # $ROUTE,$COPY,${FILE},$REMOTE,FAILED,${USER}
          echo "$ROUTE,$COPY,${FILE},$REMOTE,FAILED,${USER}" >> $BACKUPLOG
    elif [[ $ERRPT == '0' ]] & [[ "$BAND" == 'FAILED' ]]; then
          # Si el archivo ya existe en el log y la operación fue exitosa, se actualizará el registro correspondiente, reemplazando el valor FAILED por OK. 
          # Si la operación falló y el archivo ya existe en el log, no se realizará ninguna acción.
          sed "/${FILE}/s/FAILED/$STATUS/g" $BACKUPLOG > $BACKUPLOG.tmp
          mv $BACKUPLOG.tmp $BACKUPLOG
    else
    # Si la función recibe cualquier otro valor en $ERRPT y $BAND, se ejecutará una acción no especificada en el código (indicado por el comentario 
    # "Mandar correo").
        echo "Mandar correo"
    fi
}

# Descripción: Realiza una conexión SFTP y copia el archivo indicado en el servidor remoto.
# Parámetros:

# FILE: ruta del archivo a copiar.
# FAILED: estado de la operación (OK o FAILED)
# ROUTE: ruta de origen del archivo.
# PASSWORD_REMOTE: contraseña de acceso al servidor remoto.
# PORT_REMOTE: puerto de acceso al servidor remoto.
# USER_REMOTE: nombre de usuario de acceso al servidor remoto.
# REMOTE_SERVER: dirección IP o nombre del servidor remoto.
# REMOTE_DIR_DEST: ruta del directorio de destino en el servidor remoto.

# Variables:
# ERRPT: código de salida de la conexión SFTP.
#### Puedes mejorar el codigo usando archivos por lotes ( propuesta de cambio )
_sftp_connection(){
local FILE=$1
local FAILED=$2
local ROUTE=$3
sshpass -p ${PASSWORD_REMOTE} $SFTP -oPort=${PORT_REMOTE} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${USER_REMOTE}@${REMOTE_SERVER}:${REMOTE_DIR_DEST}<<EOF
put $FILE
EOF
ERRPT=$(echo $?)
sleep 5
_save_data_log $ERRPT $FAILED $FILE $ROUTE ${USER_REMOTE}
}

# Contiene una función llamada _copy_to_sftp_remote que se encarga de copiar un archivo al servidor remoto mediante una conexión SFTP.
# Recibe tres parámetros:

# xFile: El archivo que se va a copiar(Solicitud_20100210909_201905_09.txt).
# xBand: La bandera que indica si la copia se realizó con éxito o no.
# xRoute: La ruta donde se va a copiar el archivo.
# En esta función, se llama a la función _sftp_connection pasando los mismos tres parámetros, 
# lo que indica que se está realizando la conexión SFTP para copiar el archivo. 
# Luego, se llama a la función _remove_file para eliminar el archivo original.

#En resumen, esta función se encarga de copiar un archivo al servidor remoto mediante SFTP y de eliminar el archivo original 
# después de que se haya realizado la copia.
_copy_to_sftp_remote(){
  local xFile=$1
  local xBand=$2
  local xRoute=$3
  _sftp_connection $xFile $xBand $xRoute
  #_remove_file $xFILE
}

# La función _set_copy() tiene como objetivo copiar los archivos de una carpeta local a una carpeta remota en un servidor mediante SFTP.
# Para esto, se utiliza una variable RUTA que contiene la ruta de la carpeta local donde se encuentran los archivos a copiar 
# y una variable ROUTE que indica la ruta de la carpeta remota donde se deben copiar los archivos.
_set_copy(){
local RUTA=${RUTA_DIR_ORIGEN}
local ROUTE=$1
FAILED="OK"
cd $ROUTE

# Antes de la copia de cada archivo, se genera un archivo temporal mediante la función _generate_file_random() 
# y se utiliza como registro temporal de los archivos que se van copiando en el ciclo while, todo esto es originado
# dentro de la función _get_data 
LOGTMP=$(_get_data)

# Dentro del ciclo while, se verifica si el archivo ya ha sido copiado con anterioridad 
# al servidor remoto mediante la validación del archivo de log BACKUPLOG. 
# En caso de que ya se haya copiado, se verifica si la copia previa tuvo éxito ("OK") o si falló ("FAILED"). 
# Si la copia anterior falló, se intenta la copia nuevamente.
while read xFILE; do
local xROUTE=${xFILE%%/Solicitud*}
local xFILE=${xFILE##*/}
cd $RUTA/$xROUTE
        if [[ -f $BACKUPLOG ]]; then
            valorx=$(grep ${xFILE} $BACKUPLOG)
# Si el archivo aún no ha sido copiado, se procede a hacer la copia del archivo mediante la función _copy_to_sftp_remote().
            if [[ $valorx != "" ]]; then
                FAILED=$(echo $valorx|cut -d "," -f 5)
                  if [[ $FAILED == "FAILED" ]]; then
                    _copy_to_sftp_remote $xFILE $FAILED $ROUTE
                  fi
            else
                  _copy_to_sftp_remote $xFILE $FAILED $ROUTE
            fi
        else
          _copy_to_sftp_remote $xFILE $FAILED $ROUTE
        fi
done < $LOGTMP
# Luego de que se hayan copiado todos los archivos, se elimina el archivo temporal con la función _remove_file().
#_remove_file $LOGTMP
}

# La función _upload_sftp_cloud() tiene como objetivo llamar a la función _set_copy() para realizar 
# la copia de archivos desde una carpeta local a una carpeta remota en un servidor mediante SFTP. 
# Para esto, se utiliza una variable RUTA que contiene la ruta de la carpeta local donde se encuentran los archivos a copiar.
_upload_sftp_cloud(){
  local RUTA=${RUTA_DIR_ORIGEN}
  _set_copy $RUTA
}
_main(){
__init_program
_upload_sftp_cloud
}

main
