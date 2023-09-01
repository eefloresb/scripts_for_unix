#!/bin/bash
if [ -z "$INFILE" ]
then
  echo "ERROR: Debe especificar el archivo de servidores luego del argumento -i"
  exit 1
elif [ ! -f "$INFILE" ]
then
  echo "ERROR: El archivo de servidores especificado no existe"
  exit 1
fi

FROM_EMAIL="sysadmin@gmd.com.pe"
FECHA=$(date '+%d_%m_%Y')
FECHA_FULL=$(date)
CLIENTE="$(head -1 "$INFILE" | cut -d : -f 1 | cut -c 2-)"
SSH_USER="$(head -1 "$INFILE" | cut -d : -f 2)"
SSH_KEY="$(head -1 "$INFILE" | cut -d : -f 3)"
SSH="ssh -l $SSH_USER -i $SSH_KEY -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no"
SCP="scp -i $SSH_KEY -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no"
PAIRS=$(grep -v '^#' "$INFILE" | awk '{ print $1,$2 }' | tr ' ' :)


__log()
{
  local x MSG COLOR
  MSG="$@"
  [ -f "$LOGFILE" ] || touch "$LOGFILE"
  x=$(wc -l "$LOGFILE" | awk '{ print $1 }')
  if [ $x -eq 0 ]
  then
    cat > "$LOGFILE" <<EOF
<html><table border=1 cellpadding=1 cellspacing=1 align=center>
EOF
  fi
  if echo $MSG | grep -q "OK:"
  then
    COLOR="#00FF00"
  elif echo $MSG | grep -q "WARN:"
  then
    COLOR="#FF9900"
  elif echo $MSG | grep -q "FAIL:"
  then
    COLOR="#FF0000"
  fi
  x=$(wc -l "$LOGFILE" | awk '{ print $1 }')
  time=$(date +'%b %d %H:%M:%S')
  #sed -i -e "${x}a<tr bgcolor=$COLOR><td>$time<td>$CLIENTE</td><td>$MSG</td></tr>" "$LOGFILE"
  sed -i -e "${x}a\ 
  <tr bgcolor=$COLOR><td>$time<td>$CLIENTE</td><td>$MSG</td></tr>" "$LOGFILE"
}

__sendmail() {
  local OPTIND
  bodyfile=$(mktemp)
  mailfile=$(mktemp)
  while getopts "f:t:s:b:a:A:" PARAMS
  do
    case "$PARAMS" in
      f)
        FROM="$OPTARG"
        ;;
      t)
        TO="$OPTARG"
        ;;
      s)
        SUBJECT="$OPTARG"
        ;;
      b)
        BODY="$OPTARG"
        ;;
      a)
        ATTACHMENT_FILE="$OPTARG"
        ;;
      A)
        ATTACHMENT_NAME="$OPTARG"
        ;;
    esac
  done

  if [ -z "$FROM" ] || [ -z "$TO" ] || [ -z "$SUBJECT" ] || [ -z "$BODY" ]
  then
    echo "ERROR: Parametros insuficientes. Se requiere -f, -t, -s y -b"
    exit 1
  fi

  if [ -f "$BODY" ]
  then
    cat $BODY > $bodyfile
  else
    echo $BODY > $bodyfile
  fi

  cat > $mailfile <<EOF
From: $FROM
To: $TO
Subject: $SUBJECT
$(cat $bodyfile)

EOF

  if [ -n "$ATTACHMENT_FILE" ]
  then
    if [ -z "$ATTACHMENT_NAME" ]
    then
      echo "ERROR: Se debe indicar la ruta del adjunto (-a) y el nombre del archivo con el cual figurara el adjunto (-A)"
    elif [ -f "$ATTACHMENT_FILE" ]
    then
      unix2dos -q $ATTACHMENT_FILE
      cat $ATTACHMENT_FILE | uuencode $ATTACHMENT_NAME >> $mailfile
    fi
  fi
  sendmail -t < $mailfile
  rm -f $bodyfile $mailfile
}
