#!/bin/bash
df -gP |grep -E "dev" > /tmp/filesystem.txt
ip=$(ifconfig -a | grep -w inet | awk '{print $2}'|grep -v 127.0.0.1 |head -n 1)
sizeLun=$(lsvg rootvg | grep -Ei "Total pps" | awk -F ":" '{print $3}' | awk -F " " '{print $2}' | tr -d "(")
tsizelun=$(echo $sizeLun/1024 + 1 | bc)
echo "Ip Address, SizeLun,Filesystem,GB blocks, Used, Available, Capacity, Mounted on"
while read line; do
  filesystem=$(echo $line | awk '{print $1}')
  gblocks=$(echo $line | awk '{print $2}')
  used=$(echo $line | awk '{print $3}')
  available=$(echo $line | awk '{print $4}')
  capacity=$(echo $line | awk '{print $5}')
  mountedon=$(echo $line | awk '{print $6}')
  echo $ip,$tsizelun,$filesystem,$gblocks,$used,$available,$capacity,$mountedon
done < /tmp/filesystem.txt
