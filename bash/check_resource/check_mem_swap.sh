#!/bin/bash
PSARG="-p"
TOP="10"
[ -z "$1" ] || TOP=$1
grep VmSwap /proc/[0-9]*/status 2> /dev/null | sort -n -k 2 -r | awk '{ print $1,$2 }' | head -n $TOP |
while read arg1 mem
do
  pid=$(echo $arg1 | cut -d / -f 3)
  process=$(ps $PSARG $pid -o comm | tail -n +2)
  mem=$(echo "scale=2;$mem/1024"|bc)
  echo $pid $process $mem Mb
done
