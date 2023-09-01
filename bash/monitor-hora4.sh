#!/bin/bash
__check_ntp(){
  check_service=$($SSH $IP "which ntpq" 2>/dev/null) 
  if [[ ! -z $check_service ]]; then 
    echo "true" > /tmp/check_service
    $SSH $IP "export PATH=\$PATH:/sbin:/usr/sbin ; sudo ntpq -n -p" 2> /dev/null > $result    
    echo $?
  elif [[ -z $check_service ]]; then 
   echo "false" > /tmp/check_service
   $SSH $IP "export PATH=\$PATH:/sbin:/usr/sbin ; sudo chronyc -n sources" 2> /dev/null > $result
   echo $?
  fi 
}

while getopts "i:E:" OPCIONES
do
  case "$OPCIONES" in
    i)
      INFILE=$OPTARG
      ;;
    E)
      DEST_EMAIL=$OPTARG
      ;;
  esac
done
. $(dirname $0)/funciones.sh
LOGFILE="/Users/eflores/data/logs/${CLIENTE}.monitor-hora-log.html"
html_file=$(mktemp)
result=$(mktemp)
export PREFIX="OK"
cat > $html_file <<EOF
MIME-Version: 1.0
Content-Type: text/html

<html>
  <h1 align=center><font color="#4188b2" face="Arial" size="3" align=center><b> Reporte de horas de servidores </b></font></h1>
  <h1 align=center><font face="Arial" size="2" align=center><b> Validacion desfase de hora con servidor NTP </b></font></h1>
  <h1 align=center><font face="Arial" size="2" align=center><b> De haber desfase o falla de servicio NTP se debera crear el respectivo ticket de revision</b></font></h1>
  <table border="1" cellpadding="1" cellspacing="1" align=center>
    <tr>
      <td align=center><strong><font face=Arial size=1>$FECHA_FULL</strong></td>
    </tr>
  </table>
  <table border="1" cellpadding="2" cellspacing="1" align=center>
    <tr>
      <th><font face=Arial size=1.5 color="#4188b2">Item</font></th>
      <th><font face=Arial size=1.5 color="#4188b2">Servidor</font></th>
      <th><font face=Arial size=1.5 color="#4188b2">IP</font></th>
      <th><font face=Arial size=1.5 color="#4188b2">Desfase Milisegundos</font></th>
      <th><font face=Arial size=1.5 color="#4188b2">Estado</font></th>
    </tr>
EOF
i=1
for pair in $PAIRS
do
  IP=$(echo $pair | cut -d : -f 1)
  SERVIDOR=$(echo $pair | cut -d : -f 2)
  BGCOLOR="#00FF00"
  STATUS="OK"
  ec=$(__check_ntp)
  if [ $ec -eq 255 ]
  then
    BGCOLOR="#FF0000"
    STATUS="Servidor offline"
    PREFIX="WARNING"
    OFFSET="???"
    __log "FAIL: No se pudo conectar al servidor $SERVIDOR/$IP Ha fallado la consulta de hora."
    #__sendmail -f $FROM_EMAIL -t $DEST_EMAIL -s "[$CLIENTE] WARNING: Monitoreo de hora fallido en $SERVIDOR/$IP" -b "No se pudo realizar el monitoreo de hora (NTP) de $SERVIDOR/$IP: No se pudo conectar al servidor"
    echo "<tr><td align=center><strong><font face=Arial size=1>$i</strong></td><td align=center><font face=Arial size=1><b>$SERVIDOR</b></font></td><td align=center><font face=Arial size=1><b>$IP</b></font></td><td align=center><font face=Arial size=1>$OFFSET</td>" >> $html_file
    echo "<td align=center BGCOLOR="$BGCOLOR"><font face=Arial size=1>$STATUS</td></tr>" >> $html_file
    i=$(($i+1))
  else
    #OFFSET=$(grep -E "^.([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]" $result | grep -v "127.0.0.1" | head -1 | awk '{ print $9 }')
    xntp=$(cat /tmp/check_service)
    if [[ $xntp == "true" ]]; then 
      OFFSET=$(grep -E "^.([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]" $result | grep -v "127.0.0.1" | head -1 | awk '{ print $9 }')
    else 
      OFFSET=$(grep -E '^\^\*[[:blank:]]+([0-9]{1,3}\\.){3}[0-9]{1,3}[[:blank:]]+' $result | grep -v "127.0.0.1"|awk '{print$7}')
    fi
    if [ -z "$OFFSET" ]
    then
      OFFSET="???"
      DESFASE="2"
    else
      if [[ $xntp == "true" ]]; then 
          DESFASE=$(echo $OFFSET | cut -d . -f 1 | tr -d '-')
      else   
          DESFACE=$(echo $OFFSET|tr -d "([|]|+|-)")
      fi
    fi
    echo "<tr><td align=center><strong><font face=Arial size=1>$i</strong></td><td align=center><font face=Arial size=1><b>$SERVIDOR</b></font></td><td align=center><font face=Arial size=1><b>$IP</b></font></td><td align=center><font face=Arial size=1>$OFFSET</td>" >> $html_file
    i=$(($i+1))

     __desface_ntp(){
        local DESFASE=$1
        if [[ $DESFASE -lt 250 ]]; then 
            __log "OK: La hora del servidor $SERVIDOR/$IP es la correcta y actualizada"
        else 
            BGCOLOR="#FF9900"
            STATUS="DESFASE"
            PREFIX="WARNING"
            __log "WARN: Hay un desfase de la hora en el servidor $SERVIDOR/$IP que debe ser corregido"
        fi
     }
     __desface_chronyd(){
        local DESFASE=$1
        local UNIDAD=$(echo "$DESFACE" | grep -oE '[a-z]+$')
        if [[ "$UNIDAD" == "ms" ]] || [[ "$UNIDAD" == "us" ]]; then
            __log "OK: La hora del servidor $SERVIDOR/$IP es la correcta y actualizada"
        elif [[ "$UNIDAD" == "s" ]]; then
            BGCOLOR="#FF9900"
            STATUS="DESFASE"
            PREFIX="WARNING"
            __log "WARN: Hay un desfase de la hora en el servidor $SERVIDOR/$IP que debe ser corregido"
        fi
     }

    if [ "$OFFSET" = "???" ]; then
      BGCOLOR="#FF9900"
      if [[ $xntp == "true" ]]; then 
        STATUS="NTP down"
      else
        STATUS="CHRONYD down"
      fi
      PREFIX="WARNING"
      __log "WARN: El servicio NTP/CRHONYD parece no estar activo en el servidor $SERVIDOR/$IP"
    elif [[ $xntp == "true" ]]; then
        __desface_ntp $DESFASE         
    elif [[ $xnt == "false " ]]; then
        __desface_chronyd $DESFASE  
    fi
    echo "<td align=center BGCOLOR="$BGCOLOR"><font face=Arial size=1>$STATUS</td></tr>" >> $html_file
  fi
done
cat >> $html_file <<EOF
</table>
<br>
</table>
<p>---
<br>
Este mensaje fue enviado automaticamente, por favor no responder.
</html>
EOF
#__sendmail -f $FROM_EMAIL -t $DEST_EMAIL -s "[$CLIENTE] $PREFIX: Reporte de horas de servidores" -b $html_file 
#rm -f $html_file $result
