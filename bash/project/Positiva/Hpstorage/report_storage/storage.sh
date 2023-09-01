#!/bin/bash
cd /data/script
_x_lun(){
IP=$1
while read line; do
LUNAME=$line
HOSTMAP=$(ssh admcanv01@$IP lsvdiskhostmap $LUNAME | tail -n +2 | awk '{print $5}')
  for i in $HOSTMAP;do
    echo $IP,$LUNAME,$i >> reporte_hp_storage
  done
done<storage_lung
}

_x_hpstorage(){
rm reporte_hp_storage
echo "IP,LUNNAME,HOSTNAME" > reporte_hp_storage
  for IP in $(cat hpstorage.ip|awk '{print $1}'); do
      _x_lun $IP
  done

}

_x_hpstorage
