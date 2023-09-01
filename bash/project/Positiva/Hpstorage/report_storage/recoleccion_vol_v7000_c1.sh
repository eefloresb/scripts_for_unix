#!/bin/bash
cd /data/script/
DATE=`date +%Y-%m-%d`
TMP1=/tmp/recoleccion1_storage_cot1_v7000.txt
TMP3=/tmp/Lista_Volumenes_v7000_$DATE.txt
ssh admcanv01@10.100.10.14 lsvdisk > $TMP1
awk -f markup_all $TMP1 > $TMP3
echo "Reporte de recoleccion de Volumenes V7000 COT1 La Positiva - fecha $DATE" | mailx  -s "Lista de Volumenes V7000 COT1 La Positiva - fecha $DATE" -a $TMP3 marco.esquivel@lapositiva.com.pe eduardo.ortiz@lapositiva.com.pe mmachado@canvia.com rsanchezm@canvia.com hloayzac@canvia.com
