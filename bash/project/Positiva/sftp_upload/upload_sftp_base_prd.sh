#!/bin/bash
## Autor: eflores@canvia.com
## Licencia: gplv2
## Version: 1.2
## /tmp/Solicitud_20100210909_20221207_01.txt
### SOPORTE DESARROLLO ###
## file1.TXT
## file2.TXT
## file3.TXT
## /tmp/Solicitud_20100210909_20221207_01.txt
## /tmp/Solicitud_20100210909_20221207_02.txt
## /tmp/Solicitud_20100210909_20221207_03.txt
#4/5/23
# Manejo de Eventos

# Valores ha ser cambiados de acuerdo al entorno productivo
#USER_LOG: Usuario del entorno ( prd - qa -dev ) ejemplo
# prdadm ==> prd
# qaadm ==> qa
# devadm ==> dev
#REMOTE_IP_DESTINO: sftp interno para cada entorno

#Usuario de sap en el entorno productivo
USER_LOG="prdadm"
USER="sap_sftp"
COPY="copy"
STATUS="OK"
OS=$uname
DAY=$(date +%d)
mAYMONTH=$(date +%d%m)
REMOTE_IP_DESTINO="10.10.30.161"
#REMOTE_IP_DESTINO="192.168.56.14"
BACKUPLOG="/var/log/sapsftp/logsapcopyremote.log"
REMOTECOPYLOG="/var/log/sapsftp/copyremotestatus.log"
RUTA_DIR_ORIGEN="/tmp"
#RUTA_DIR_DESTINO="/FTP"
RUTA_DIR_DESTINO="/Nexus"
#KEY="/home/sap_sftp/.ssh/id_rsa"
#KEY="/SAPDOCS/APP1/SPLA/SPLA_EG/.ssh/id_rsa"
KEY="/keys/id_rsa"
DATE=$(date "+%y-%m-%d %H:%M")

if [[ ! -f $BACKUPLOG ]];then
  touch $BACKUPLOG
  chown -R ${USER_LOG}:sapsys ${BACKUPLOG}
  chmod -R 775 ${BACKUPLOG}
fi
if [[ ! -f $REMOTECOPYLOG ]];then
  touch $REMOTECOPYLOG
  chown -R ${USER_LOG}:sapsys ${REMOTECOPYLOG}
  chmod -R 775 ${REMOTECOPYLOG}
fi

_upload_data(){
local LOGTMP=$1
#### el para
find * -name "Solicitud_*.txt" -prune -type f > $LOGTMP
}

#generate file random
_generate_file_random(){
RAND=$(od -N 4 -tu /dev/random | awk 'NR==1 {print $2}')
tmpfile=/tmp/temp.${RAND}
touch $tmpfile
_upload_data $tmpfile
echo $tmpfile
}

_get_data(){
local LOGTMP=$(_generate_file_random)
echo $LOGTMP
}

__send_mail() {
  # Funcion que envia un e-mail con parametros personalizables
  #
  # $1 : Remitente mostrado
  # $2 : Destinatario
  # $3 : Asunto del mensaje
  # $4 : Cuerpo del mensaje

mail -s "$3" -r "$1" "$2" <<EOF
$4

---
Este mensaje fue enviado automáticamente, por favor no responder.
EOF
}
# Sino tienes conectividad
__ERRK01(){
  echo "
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Checklist de Validaciones</title>
  <style>
    table {
      width: 100%;
      border-collapse: collapse;
      font-family: Arial, sans-serif;
    }

    th, td {
      padding: 8px;
      text-align: left;
      border: 1px solid #ccc;
    }

    th {
      background-color: #f2f2f2;
      font-weight: bold;
    }

    tr:nth-child(even) {
      background-color: #f2f2f2;
    }

    .checkmark {
      display: inline-block;
      width: 20px;
      height: 20px;
      background-color: #ddd;
      border-radius: 50%;
      text-align: center;
      line-height: 20px;
      color: white;
    }

    .checkmark.checked {
      background-color: #4CAF50;
    }
  </style>
</head>
<body>
  <table>
    <thead>
      <tr>
        <th>Validación</th>
        <th>Estado</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Validar que los campos esten habilitados: </td>
        <td><div class="checkmark checked">&#10060;</div></td>
      </tr>
      <tr>
        <td>Networking: Existe conectividad con el servidor sftp interno?</td>
        <td><div class="checkmark checked">&#10060;</div></td>
      </tr>
      <tr>
        <td>System Operating: EL usuario sap_sftp existe en el servidor sftp interno?</td>
        <td><div class="checkmark checked">&#10060;</div></td>
      </tr>
      <tr>
        <td>Networking: El firewall permite la comunicación remota con el servicio</td>
        <td><div class="checkmark checked">&#10004;</div></td>
      </tr>
      <tr>
        <td>System Operating: El certificado ubicado en el directorio /keys/ existe, tiene permisos rw- --- ---</td>
        <td><div class="checkmark checked">&#10004;</div></td>
      </tr>
      <tr>
        <td>System Operating: Comprobar que la clave no presente caducidad</td>
        <td><div class="checkmark"></div></td>
      </tr>
      <tr>
        <td>System Operating: El certificado privado/publico debe existir en /keys</td>
        <td><div class="checkmark"></div></td>
      </tr>
    </tbody>
  </table>
</body>
</html>
  "
}

__handleErrorEvents(){
  if ssh -o ConnectTimeout=5 -lsap_sftp -i /keys/id_rsa $REMOTE_IP_DESTINO "echo test...connection"; then 
   echo "Connection OK"
  else
  
   echo "ERRK01"
  fi
}

__testConnection(){
  local AsuntoMSG="[Canvia/SSAA-UNIX] Failed Nexus SAP - LaPositiva"
  ERR=$(__handleErrorEvents)
  if [[ $ERR == "ERRK01" ]]; then
  # Problemas __ERRK01
  # Networking:       Conectividad con el servidor sftp interno
  # System Operating: De usuario sap_sftp no existe en el servidor ftp interno
  # Networking:       Con el firewall, no se conecta al puerto 22 del servidor ftp interno
  # System Operating: Con el certificado ubicado en el directorio /keys/ no se tiene permisos de lectura(umask 0000), 
  #                   o el usuario no tiene permisos de lectura, o el directorio no existe debido a que ha sido movido o borrado
  # System Operating: El certificado ubicado en /keys con el nombre id_rsa no existe, fue borrado, o no tiene los permisos para ser leído. 
Problemas con la caducidad de la clave
    ERRK01=$(__ERRK01)
    __send_mail robot@lapositiva.com eflores@canvia.com $AsuntoMSG $ERRK01
    exit 0
  fi
}

### Copia remotamente el archivo
_copy_remote(){
  local xFILE=$1
  local BAND=$2
  local xSTAT=$(echo ${xFILE}|awk -F "_" '{print $1}')
  local xRUC=$(echo ${xFILE}|awk -F "_" '{print $2}')
  local xDATE=$(echo ${xFILE}|awk -F "_" '{print $3}')
  local value=($(echo $xDATE|awk -v ORS="" '{ gsub(/./,"&\n") ; print }'))
  local xYEAR=${value[0]}${value[1]}${value[2]}${value[3]}
  local xMONTH=${value[4]}${value[5]}
  local xITEM=$(echo ${xFILE}|awk -F "_" '{print $4}')
         ssh -f $USER@${REMOTE_IP_DESTINO} -i ${KEY} -q -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=yes -o PasswordAuthentication=no "if [[ ! -d ${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH ]]; then mkdir -p ${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH; fi"
        local RUTA_DIR_DESTINO="${RUTA_DIR_DESTINO}/$xSTAT/$xRUC/$xYEAR/$xMONTH"
        rsync -Pav -e "ssh -l $USER -i $KEY" $xFILE $USER@${REMOTE_IP_DESTINO}:${RUTA_DIR_DESTINO}/ 1>>$REMOTECOPYLOG        
        if [[ $? == '0' ]] & [[ $BAND == 'OK' ]]; then
            # Cambiar de permiso al finalizar el copiado 
            ssh -f $USER@${REMOTE_IP_DESTINO} -i ${KEY} -q -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=yes -o PasswordAuthentication=no "if [[ -f ${RUTA_DIR_DESTINO}/$xFILE ]]; then chmod 666 ${RUTA_DIR_DESTINO}/$xFILE; fi"
            echo "$COPY,$DATE,${xFILE},${REMOTE_IP_DESTINO},$STATUS" >> $BACKUPLOG
            _remove_file $xFILE
        elif [[ $? != '0' ]] & [[ $BAND == 'OK' ]]; then
              echo "$COPY,$DATE,${xFILE},$REMOTE,FAILED" >> $BACKUPLOG
        elif [[ $? == '0' ]] & [[ $BAND == 'FAILED' ]]; then
              ssh -f $USER@${REMOTE_IP_DESTINO} -i ${KEY} -q -n -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=yes -o PasswordAuthentication=no "if [[ -f ${RUTA_DIR_DESTINO}/$xFILE ]]; then chmod 666 ${RUTA_DIR_DESTINO}/$xFILE; fi"
              sed "/${XFILE}/s/FAILED/$STATUS/g" $BACKUPLOG > $BACKUPLOG.tmp
              sed "/${XFILE}/ s/$/${DATE}/" $BACKUPLOG.tmp > output_file
              rm $BACKUPLOG.tmp
              mv output_file $BACKUPLOG
              _remove_file $xFILE
        else
            echo "Mandar correo"
        fi
}

_set_copy(){
__testConnection
ROUTE="${RUTA_DIR_ORIGEN}"
cd $ROUTE
LOGTMP=$(_get_data)
while read xFILE; do
FAILED="OK"
        if [[ -f $BACKUPLOG ]]; then
            valorx=$(grep ${xFILE} $BACKUPLOG)
            if [[ $valorx != "" ]]; then
                FAILED=$(echo $valorx|cut -d "," -f 5)
                  if [[ $FAILED == "FAILED" ]]; then
                    _copy_remote $xFILE $FAILED
                  fi
            else
                  _copy_remote $xFILE $FAILED
            fi
        else
          _copy_remote $xFILE $FAILED
        fi
done < $LOGTMP
_remove_file $LOGTMP
}

_remove_file(){
  rFILE=$1
  rm $rFILE
}
_set_copy

