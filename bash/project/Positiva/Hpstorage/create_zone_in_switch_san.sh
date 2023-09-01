# Automatizando la creación de zonas y alias en un conmutador de red de fibra óptica (Fibre Channel switch).
# Copyright (C) 2023 efloresb.pe
#
# Este programa es software libre: puedes redistribuirlo y/o modificarlo
# bajo los términos de la Licencia Pública General GNU publicada por
# la Free Software Foundation, ya sea la versión 3 de la Licencia, o
# (a su elección) cualquier versión posterior.

# Este programa se distribuye con la esperanza de que sea útil,
# pero SIN NINGUNA GARANTÍA; sin siquiera la garantía implícita de
# COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO PARTICULAR. Ver el
# Licencia pública general GNU para más detalles.

# Zonificar un servidor AIX con 4 patitas o fc

#                                       DETALLE MANUAL
# ----------------------------------------------------------------------------------------------
#VIOS2_S822_4                           =====> FABRIC02
#fsc0 (U78CB.001.WZS0K7E-P1-C9-T1)
#c0:50:76:09:73:43:00:f6 (Unknown-Unknown)
#c0:50:76:09:73:43:00:f7 (Unknown-Unknown)
#
# VIOS2_S822_4                          =====> FABRIC01
#fsc1 (U78CB.001.WZS0K7E-P1-C9-T2)
#c0:50:76:09:73:43:00:f8 (Unknown-Unknown)
#c0:50:76:09:73:43:00:f9 (Unknown-Unknown)
#
#
#VIOS1_S822_4                           =====> FABRIC01
#fsc0 ( U78CB.001.WZS0K7E-P1-C7-T1)
#c0:50:76:09:73:43:00:f2 (Unknown-Unknown)
#c0:50:76:09:73:43:00:f3 (Unknown-Unknown)
#
#
#VIOS1_S822_4                           =====> FABRIC02
#fsc1 (U78CB.001.WZS0K7E-P1-C7-T1)
#c0:50:76:09:73:43:00:f4 (Unknown-Unknown)
#c0:50:76:09:73:43:00:f5 (Unknown-Unknown)
#
#   +------+                                        +------+  
#   |      |                                        |      |  
#   |Switch|----------------------------------------|Switch|
#   |      |                                        |      |  
#   +------+                                        +------+  
#   10.100.100.170
#   IBM_2498_F48
#   Fabric 1
######################### PROCEDIMIENTO Manual Fabric 1 #################################
#alicreate pS822_4_LPTESTSA01_WWN1,c0:50:76:09:73:43:00:f2
#alicreate pS822_4_LPTESTSA01_WWN2,c0:50:76:09:73:43:00:f3
#alicreate pS822_4_LPTESTSA01_WWN5,c0:50:76:09:73:43:00:f8
#alicreate pS822_4_LPTESTSA01_WWN6,c0:50:76:09:73:43:00:f9
#zonecreate pS822_4_LPTESTSA01_WWN1_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN1;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN1_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN1;V9000_N2_P1"
#zonecreate pS822_4_LPTESTSA01_WWN2_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN2;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN2_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN2;V9000_N2_P1"
#zonecreate pS822_4_LPTESTSA01_WWN5_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN5;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN5_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN5;V9000_N2_P1"
#zonecreate pS822_4_LPTESTSA01_WWN6_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN6;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN6_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN6;V9000_N2_P1"
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN1_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN1_V9000_N2_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN2_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN2_V9000_N2_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN5_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN5_V9000_N2_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN6_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN6_V9000_N2_P1
#cfgsave
#cfgenable GENERALES
##########################################################################################
#
#   +------+                                        +------+  
#   |      |                                        |      |  
#   |Switch|----------------------------------------|Switch|
#   |      |                                        |      |  
#   +------+                                        +------+  
#                                                 10.100.100.171
#                                                  IBM_2498_F48
#                                                    Fabric 2
######################### PROCEDIMIENTO Manual Fabric 2 ##################################
#alicreate pS822_4_LPTESTSA01_WWN3,0:50:76:09:73:43:00:f4
#alicreate pS822_4_LPTESTSA01_WWN4,0:50:76:09:73:43:00:f5
#alicreate pS822_4_LPTESTSA01_WWN7,c0:50:76:09:73:43:00:f6
#alicreate pS822_4_LPTESTSA01_WWN8,c0:50:76:09:73:43:00:f7
#zonecreate pS822_4_LPTESTSA01_WWN3_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN3;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN3_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN3;V9000_N2_P1"
#zonecreate pS822_4_LPTESTSA01_WWN4_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN4;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN4_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN4;V9000_N2_P1"
#zonecreate pS822_4_LPTESTSA01_WWN7_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN7;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN7_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN7;V9000_N2_P1"
#zonecreate pS822_4_LPTESTSA01_WWN8_V9000_N1_P1,"pS822_4_LPTESTSA01_WWN8;V9000_N1_P1"
#zonecreate pS822_4_LPTESTSA01_WWN8_V9000_N2_P1,"pS822_4_LPTESTSA01_WWN8;V9000_N2_P1"
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN3_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN3_V9000_N2_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN4_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN4_V9000_N2_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN7_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN7_V9000_N2_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN8_V9000_N1_P1
#cfgadd GENERALES,pS822_4_LPTESTSA01_WWN8_V9000_N2_P1
#cfgsave
#cfgenable GENERALES
#######################################################################################
#                                      AUTOMATIZADO
# ----------------------------------------------------------------------------------------------
#                                     +----------+
#                                     | Ansible  |
#                                     | Server   |
#                                     +----+-----+
#                                          | 
#                          +---------------+---------------+ . . .
#                          |               |               |
#                       +--v--+         +--v--+         +--v--+
#                       | SAN |         | SAN |  . . .  | SAN |
#                       |Sw 1 |         |Sw 2 |         |Sw n |
#                       +-----+         +-----+         +-----+
#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Inicio del código @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#!/bin/bash
DATE=$(date +%Y/%m/%d-%H:%m)
# Define el nombre del canal de fibra
NAMEFABRIC="pS822"
NUMBERFABRIC="4"
USER="admin"
REMOTE_HOST="10.100.100.170"
# Define el nombre de host de la máquina AIX/LINUX
HOSTNAME="LPTESTSA01"
#SERIAL DEL FABRIC1 empezando desde el VIOS1/VIOS2
SERIALNUMBERVIOS=(
"c0:50:76:09:73:43:00:f2" 
"c0:50:76:09:73:43:00:f3" 
"c0:50:76:09:73:43:00:f8" 
"c0:50:76:09:73:43:00:f9"
)
# Define los números de serie del canal de fibra para cada VIOS
NAMEALIASTORAGE="V9000"
NAMESAVE="GENERALES"
# Inicializa el contador j
declare -i j=0
#Encabezado del reporte
printf "DATE,Fibra Channel,NP,Status\n" > /tmp/register
# Función para crear alias y zonas en el conmutador de red de fibra óptica
__alicreate(){
  # Itera sobre el rango de 1 a 6
  for (( i=1;i<7;i++ )); do
    # Si i es 1, 2, 5 o 6, crea alias y zonas
    if [[ $i == "5" ]] || [[ $i == "6" ]] || [[ $i == "1" ]] || [[ $i == "2" ]]; then 
      # Crea un alias
      COMMAND="alicreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i},${SERIALNUMBERVIOS[$j]}"
      # Ejecuta el comando declarado por ssh hacia el v9000 de destino
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      # El uso de la barra invertida (\) en este script es para forzar a la shell a interpretar lo que sigue como un carácter literal. 
      # Esto es especialmente útil cuando se utiliza el comando 'echo' para probar o depurar el script. 
      #echo zonecreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N1_P1,\"${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}\;${NAMEALIASTORAGE}_N1_P1\"
      ######### Crea zonas
      COMMAND="zonecreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N1_P1,\"${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i};${NAMEALIASTORAGE}_N1_P1\""
      # Ejecuta el comando declarado por ssh hacia el v9000 de destino
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      #echo zonecreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N2_P1,\"${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}\;${NAMEALIASTORAGE}_N2_P1\"
      ######### Crea zonas
      COMMAND="zonecreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N2_P1,\"${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i};${NAMEALIASTORAGE}_N2_P1\""
      # Ejecuta el comando declarado por ssh hacia el v9000 de destino
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
       # Añade las zonas a la configuración
      COMMAND="cfgadd ${NAMESAVE},${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N1_P1"
      # Ejecuta el comando declarado por ssh hacia el v9000 de destino
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      COMMAND="cfgadd ${NAMESAVE},${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N2_P1"
      # Ejecuta el comando declarado por ssh hacia el v9000 de destino
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      j=$j+1
      "$DATE,${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE},N1_P1,registrado" >> /tmp/register
      "$DATE,${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE},N2_P1,registrado" >> /tmp/register
    fi
  done
  # Guarda la configuración
  # echo "sí" | comando_que_pide_confirmacion
  COMMAND="cfgsave"
  # Ejecuta el comando declarado por ssh hacia el v9000 de destino
  ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
  COMMAND="cfgenable ${NAMESAVE}"
  # Ejecuta el comando declarado por ssh hacia el v9000 de destino
  ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
}
__alicreate

##################################### ********************  ##############################################################
##################################### ********************  ##############################################################
                                      # Ejemplo02
##################################### ********************  ##############################################################
##################################### ********************  ##############################################################
# Aplica para varios equipos 1,2,3...n

#!/bin/bash
DATE=$(date +%Y/%m/%d-%H:%m)
NAMEFABRIC="pS822"
NUMBERFABRIC="4"
USER="admin"
NAMEALIASTORAGE="V9000"
NAMESAVE="GENERALES"
printf "DATE,HOSTREMOTE,HOSTNAME,Fibra Channel,NP,Status\n" > /tmp/register
__alicreate(){
  local HOSTNAME=$1
  local SERIALNUMBERVIOS =$2
  local REMOTE_HOST=$3
  local BAND=$4
  local i=$BAND
      COMMAND="alicreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i},${SERIALNUMBERVIOS}"
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      COMMAND="zonecreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N1_P1,\"${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i};${NAMEALIASTORAGE}_N1_P1\""
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      COMMAND="zonecreate ${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N2_P1,\"${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i};${NAMEALIASTORAGE}_N2_P1\""
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      COMMAND="cfgadd ${NAMESAVE},${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N1_P1"
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      COMMAND="cfgadd ${NAMESAVE},${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE}_N2_P1"
      ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
      "$DATE,${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE},N1_P1,registrado" >> /tmp/register
      "$DATE,${NAMEFABRIC}_${NUMBERFABRIC}_${HOSTNAME}_WWN${i}_${NAMEALIASTORAGE},N2_P1,registrado" >> /tmp/register
    fi
  done
  COMMAND="cfgsave"
  ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
  COMMAND="cfgenable ${NAMESAVE}"
  ssh ${USER}@${REMOTE_HOST} \"$COMMAND\"
}
__alicreate

main(){
while IF= read line
do
local HOSTNAME=$(cut -d : -f 1 $line)
local SERIALNUMBERVIOS=$(cut -d : -f 2 $line)
local REMOTE_HOST=$(cut -d : -f 3 $line)
local BAND=$(cut -d : -f 4 $line)
__alicreate $HOSTNAME $SERIALNUMBERVIOS $REMOTE_HOST $BAND
done < SerialNumbers.txt
}

## EL texto de SerialNumbers.txt sería 
LPTESTSA01,"c0:50:76:09:73:43:00:f2",10.100.100.170,1 
LPTESTSA01,"c0:50:76:09:73:43:00:f3",10.100.100.170,2
LPTESTSA01,"c0:50:76:09:73:43:00:f8",10.100.100.170,5
LPTESTSA01,"c0:50:76:09:73:43:00:f9",10.100.100.170,6
LPTESTSA01,"c0:50:76:09:73:43:00:f4",10.100.100.171,3
LPTESTSA01,"c0:50:76:09:73:43:00:f5",10.100.100.171,4
LPTESTSA01,"c0:50:76:09:73:43:00:f6",10.100.100.171,7
LPTESTSA01,"c0:50:76:09:73:43:00:f7",10.100.100.171,8