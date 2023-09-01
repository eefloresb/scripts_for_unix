_get_sftp(){
local ROUTE=$1
local USER=$2
local PASSWORD=$3
sshpass -p $PASSWORD $SFTP -oPort=$PORT $USER@$REMOTE:$DESTCOPY/$USER/$ROUTE <<EOF
ls -1
EOF
}

_compare_data_vs_sftp_data(){
#_get_sftp_data $i $BACKUPLOG $USER $PASSWORD
local ROUTE=$1
local BACKUPFILELOG=$2
local USER=$3
local PASSWORD=$4
if [[ ! -f $BACKUPFILELOG ]]; then 
  touch $BACKUPFILELOG
fi
LOGTMP1=$BACKUPFILELOG
LOGTMP2=$(_get_data)
LOGTMP3=$(_get_data)
$(_get_sftp $ROUTE $USER $PASSWORD) > $LOGTMP2
tail -n +3 $LOGTMP2 > $LOGTMP3
mv $LOGTMP3 $LOGTMP2
while read line; do 
  if ! grep -w $line $LOGTMP1; then 
      _compare_data_vs_file_log $ROUTE $line
  fi
done < $LOGTMP2
}
