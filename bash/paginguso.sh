#!/bin/bash
MINUTES="20"
CRIT_VALUES="200 200 10"
WARN_VALUES="100 100 5"
while getopts "m:w:c:" OPTS
do
  case "$OPTS" in
    m)  
      MINUTES=$OPTARG
      ;;  
    w)  
      WARN_VALUES=$OPTARG
      ;;  
    c)  
      CRIT_VALUES=$OPTARG
      ;;  
  esac
done

if ! which sar > /dev/null
then
  echo "ERROR: $(basename $0): sar is not installed"
  exit 1
else
  startTime=$(date -d "now -${MINUTES} minutes" +%H:%M:%S)
  read pgpgin pgpgout majflt < <(sar -B -s $startTime | grep "Average" | tail -1 | awk '{ print $2,$3,$5 }')
  if [ -z "$pgpgin" ] || [ -z "$pgpgout" ] || [ -z $majflt ]
  then
    echo "ERROR: $(basename $0): unable to get statistics in the last $MINUTES minutes"
    exit 1
  else
    read pgpginW pgpgoutW majfltW < <(echo $WARN_VALUES)
    read pgpginC pgpgoutC majfltC < <(echo $CRIT_VALUES)
    if [ ${pgpgin%.*} -ge $pgpginC ] && [ ${pgpgout%.*} -ge $pgpgoutC ] && [ ${majflt%.*} -ge $majfltC ]
    then
      # Retornar 2 como codigo de umbral critico superado
      exit 2
    elif [ ${pgpgin%.*} -ge $pgpginW ] && [ ${pgpgout%.*} -ge $pgpgoutW ] && [ ${majflt%.*} -ge $majfltW ]
    then
      # Retornar 1 como codigo de umbral warning superado
      exit 1
    else
      # Retornar 0 como codigo de umbral warning superado
      exit 0
    fi  
  fi
fi
