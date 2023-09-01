#!/bin/bash
#Autor: Dante Aguilar
#license: gplv2
cd /tmp/ 
for i in $(cat /etc/passwd | cut -d ":" -f1-4); do
username=$(echo $i | cut -d ":" -f1)
userid=$(echo $i | cut -d ":" -f3) 
sudo -l -U $username > log.txt
  if [ $(grep -E ".ALL..|.ALL.ALL." log.txt | grep -e "ALL$" | wc -l) -gt 0 -o "$userid" == 0 ]; then
    grupos=$(cut -d ":" -f2 | sed -r 's/^[[:blank:]]+//' | sed 's/ /|/g')
    echo ,$username,$grupos >> archivo.texto 
  fi
done
