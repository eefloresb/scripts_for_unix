# __Copiar archivos entre servidores remotos usando ssh/rsync__ 

**Resumen**

Se requiere copiar archivos generados en la carpeta /tmp del servidor de SAP(origen),
de los entornos dev-qa-prd, hacia un servidor remoto sftp interno(destino) dichos
archivos al ser copiados deben generar una estructura a nivel de directorios en
el servidor(destino en la ruta /Nexus/Solicitud/) del tipo

_estructura de directorios en el servidor destino_
.
├── 20100210909
│   ├── 2019
│   │   └── 05
│   │       ├── Solicitud_20100210909_201905_09.txt

sap_server ==> JobShell ==> ./upload_sftp.sh                            ==>     sftp_interno
                              Solicitud_20100210909_201905_09.txt               /Nexus/Solicitud/20100210909/2019/05/Solicitud_20100210909_201905_09.txt

Para realizar dicho proceso se debe ejecutar el siguiente procedimiento:

a. Copiar archivos sftp_upload.sh en el servidor SAP en la ruta /sap/doc/shell con el nombre upload_sftp.sh(SSAA/UNIX)
b. Programar JOB a nivel de SAP(Client)
d. Creación de la estructura solicitada(script) 
e. Copiado del archivo con formato Solicitud...

_Servidores_

Lista de Servidores involucrados: 

  1. **Server PRD**: 10.100.50.25, 10.100.50.23 (misma instancia)
  2. **Server SFTP Interno**: 10.10.30.161

_Configuración_
1) Validar el usuario con el cual está corriendo la aplicación, ejemplo: prdadm ( servidores prd) qadm(servidores de qa) devadm(servidores dev)

_Instalación_

_Procedimiento de SAP_

1) La herramienta de SAP ejecuta un proceso job a nivel de SAP este genera el archivo en la ruta /tmp/ con el nombre Solicitud_20601978572_202212_02.txt

2) La herramienta de SAP ejecuta el script de la ruta /sapdocs/shells con nombre upload_sftp.sh, el se encarga de copiar el archivo Solicitud.. y crear la estructura de directorios en función del archivo copiado.

## __Instalacion__

1. Crear el usuario sap_sftp

2. En producción crear el directorio /keys con el id del usuario prdadm y group sapsys
  * copiar el siguiente contenido 
    Solicitud_20100210909_201905_10.txt
TotalRegistros|29998
20100210909|37159|91|0000-00000219|2019/03
20100210909|00000000099|91|0000-00001109|2019/03
20100210909|EER1106302F1|91|0000-00002580|2019/04
20100210909|37159|91|0000-00000119|2019/02
20100210909|00000000099|91|0000-00001108|2019/03
20100210909|0009740425P|91|0000-00439296|2019/03
20100210909|216662830015|91|0000-00004610|2019/04
20100210909|20143229816|01|F021-00168440|2019/03
20100210909|20100211034|14|0000-09646934|2019/04
20100210909|20100049181|01|F301-00026470|2019/04
20100210909|20101087647|01|F027-00122504|2019/04
20100210909|20125986880|01|F007-00003733|2019/04
20100210909|10404038198|02|E001-00000077|2019/04
20100210909|20100861161|01|F001-00000233|2019/04
20100210909|20505897812|01|F121-00005437|2019/04
20100210909|20109072177|01|F204-05171964|2019/04
20100210909|20100017491|14|0000-06275468|2019/04
20100210909|20508565934|01|F160-00016216|2019/04
20100210909|20125986880|01|F007-00015498|2019/04
20100210909|10075793168|01|0001-00032804|2019/04
20100210909|10292356817|01|F002-00016281|2019/04
20100210909|10292356817|01|F002-00016221|2019/04
20100210909|10292356817|01|F002-00016280|2019/04
20100210909|20100219108|01|F001-00004463|2019/04
20100210909|20100219108|01|F001-00004464|2019/04
20100210909|20100219108|01|F001-00004465|2019/04
20100210909|20100219108|01|F001-00004466|2019/04
20100210909|20100219108|01|F001-00004467|2019/04
20100210909|20100219108|01|F001-00004473|2019/04

  * Servidores productivos 
    1. 10.100.50.19 ==> falta instalar rsync
    2. 10.100.50.18 ==> falta instalar rsync
    3. 10.100.50.24 ==> falta instalar rsync
    4. 10.100.50.23 ==> 10.100.50.25 ( misma instancia)
  * En cada servidor ejecutar el siguiente procedimiento
```bash
mkdir /keys
chown prdadm:sapsys /keys
umask 0066
cat > /keys/id_rsa<<EOF
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEAqXkDoo944+1oqiVbz9nUHoY2Ev8TP85EdjcFmbEJUmcZV8Xcg7w/
8fx4PMF2XyWPb5dynYeA2y01nBUltLxPnLkFgQgZ9IrwijzTColvjsHVgKJ0pJJB77Keec
xHy1iWxIE5tjeiDL5br6CsKg4htq9SOIpbAqI9fU4Tr09ZJf/mszH8NW+f/Vebo4HFLxyD
YU9/Zd4+evbNK+0Yc14sBDRgiLlKSFMhg8O84QeXSVRZ9Jx1pbq+Q3GA4SYJzhm05SLWDX
uzAMcA55Il3Sk3e94JLWVw+iwrqewK4FDE3qkgeq6C86tD5PoVazozU1wwNZ3K0w5pomZd
OW8YUYRRcwAAA9jNSSj2zUko9gAAAAdzc2gtcnNhAAABAQCpeQOij3jj7WiqJVvP2dQehj
YS/xM/zkR2NwWZsQlSZxlXxdyDvD/x/Hg8wXZfJY9vl3Kdh4DbLTWcFSW0vE+cuQWBCBn0
ivCKPNMKiW+OwdWAonSkkkHvsp55zEfLWJbEgTm2N6IMvluvoKwqDiG2r1I4ilsCoj19Th
OvT1kl/+azMfw1b5/9V5ujgcUvHINhT39l3j569s0r7RhzXiwENGCIuUpIUyGDw7zhB5dJ
VFn0nHWlur5DcYDhJgnOGbTlItYNe7MAxwDnkiXdKTd73gktZXD6LCup7ArgUMTeqSB6ro
Lzq0Pk+hVrOjNTXDA1ncrTDmmiZl05bxhRhFFzAAAAAwEAAQAAAQAXLsOtiBzMaRyJMeUW
UMDwkAFzpcr3TnsVBL/SX2JcEFhqJlnc93Jz4sp73ScZKuUtKbV3ESMyWEPeHxJyX9QwJy
s2lGoghqUS8/EWnuhQyfkvyIlWPd+hL3j4RlaH3Y16QgcoAwI65gtawgrrEdXQzLjdnSeH
+7OXoYeV0q/qP5c/shh062bRIgCtvxCYterzFjPN+9cBvkcZZ9e8iuT3Ym20oyJiwZrP5T
U3UXjjwLsDhS5Ayvx5+wIZKSOnSfGNJD33KykTjzCCsbHr7iQrVDUET1fQKmK/IIHH6sao
8398cWzJWLWXhV5gxzEF1OAIzguXTJRWEdrj7zCDmMd5AAAAgHaLOTXxVkbzkZsk+WBW3G
hLBfoaU4QAQ3d4esorLNvsZ3ZNay0BGzDyEVX0MGyfucNXJSZXMZoOQw99PagD+U9DjWiM
ayLrGXywfB8Nt64N6/3sDoX5ZXi9qY2+grWvLsEXnMwlwn4aPa9uAHrvC3cP0UR2Mu5ABU
7pzDKd814DAAAAgQDZsnxxj5lB9A0RoPLLiQeyFlAFyYzpoTNGXnX2zQ3wafryKoKKRUoL
WXLn2BC6yZq/81PWFfCNxHVtJy0d3g8HDws3y5j+Y9iPmgx7Qj4sgaPK5T9ecqG96CWJ8E
smnnEJBpPegj8Z9G3pO/6oct/4rWwqg1qXjrbus4kfUAm6dwAAAIEAx0pmqr5mLil6deoC
EpWIcs1+Ae3h4S8qRhOKzVfEjam3/ItAHZdhrZSvNHPT7pjAHnAwCyGHu60scqPdFdhLiH
u4U1Dm9AryuVK2nxuk/lBeYnm19cJx7j30vNW8KC6Cm+VFo++CaQprggvzRjNFQF1jC2J1
YVI+sh6yTZCP4+UAAAAdZWR3aW5mbG9yZXNAYWthbmVoYWNrLTIubG9jYWwBAgMEBQY=
-----END OPENSSH PRIVATE KEY-----
EOF
chmod 600 /keys/id_rsa
chown -R prdadm:sapsys /keys/id_rsa
ssh -lsap_sftp -i /keys/id_rsa 10.10.30.161 "echo test...connection"
umask 0022
```
3. crear el archivo upload_sftp.sh a la ruta /sapdocs/shells/ y rellenarlo con la información del archivo upload_sftp_base_prd.sh
```bash
mkdir -p /var/log/sapsftp/
touch /var/log/sapsftp/copyremotestatus.log
touch /var/log/sapsftp/logsapcopyremote.log
chown -R prdadm:sapsys /var/log/sapsftp/
touch /sapdocs/shells/upload_sftp.sh
cat > /sapdocs/shells/upload_sftp.sh << EOF
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
            echo "$COPY,$DATE,${xFILE},${REMOTE_IP_DESTINO},$STATUS" >> $BACKUPLOG
            _remove_file $xFILE
        elif [[ $? != '0' ]] & [[ $BAND == 'OK' ]]; then
              echo "$COPY,$DATE,${xFILE},$REMOTE,FAILED" >> $BACKUPLOG
        elif [[ $? == '0' ]] & [[ $BAND == 'FAILED' ]]; then
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
echo
#  rFILE=$1
#  rm $rFILE
}
_set_copy
EOF
chmod 775 /sapdocs/shells/upload_sftp.sh
touch /tmp/Solicitud_20100210909_201905_21.txt
chmod 644 /tmp/Solicitud_20100210909_201905_21.txt
cat >>/tmp/Solicitud_20100210909_201905_21.txt<<EOF
TotalRegistros|29998
20100210909|37159|91|0000-00000219|2019/03
20100210909|00000000099|91|0000-00001109|2019/03
20100210909|EER1106302F1|91|0000-00002580|2019/04
20100210909|37159|91|0000-00000119|2019/02
20100210909|00000000099|91|0000-00001108|2019/03
20100210909|0009740425P|91|0000-00439296|2019/03
20100210909|216662830015|91|0000-00004610|2019/04
20100210909|20143229816|01|F021-00168440|2019/03
20100210909|20100211034|14|0000-09646934|2019/04
20100210909|20100049181|01|F301-00026470|2019/04
20100210909|20101087647|01|F027-00122504|2019/04
20100210909|20125986880|01|F007-00003733|2019/04
20100210909|10404038198|02|E001-00000077|2019/04
20100210909|20100861161|01|F001-00000233|2019/04
20100210909|20505897812|01|F121-00005437|2019/04
20100210909|20109072177|01|F204-05171964|2019/04
20100210909|20100017491|14|0000-06275468|2019/04
20100210909|20508565934|01|F160-00016216|2019/04
20100210909|20125986880|01|F007-00015498|2019/04
20100210909|10075793168|01|0001-00032804|2019/04
20100210909|10292356817|01|F002-00016281|2019/04
20100210909|10292356817|01|F002-00016221|2019/04
20100210909|10292356817|01|F002-00016280|2019/04
20100210909|20100219108|01|F001-00004463|2019/04
20100210909|20100219108|01|F001-00004464|2019/04
20100210909|20100219108|01|F001-00004465|2019/04
20100210909|20100219108|01|F001-00004466|2019/04
20100210909|20100219108|01|F001-00004467|2019/04
20100210909|20100219108|01|F001-00004473|2019/04
EOF
su - prdadm -c /sapdocs/shells/upload_sftp.sh
```
6. En el servidor ftp interno debe aparecer la siguiente estructura
