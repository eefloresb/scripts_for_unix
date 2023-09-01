#!/bin/bash 
DATE=`date +%Y-%m-%d`
TMP1=/tmp/recoleccion1_storage_cot4_fs7200.txt
TMP3=/tmp/Lista_Volumenes_fs7200_$DATE.txt
ssh admcanv01@10.100.100.98 lsvdisk > $TMP1
awk -f markup $TMP1 > $TMP3 
