#!/bin/sh 
for i in $(cat oea_lista_aasa); do
  for j in $(cat oea_list_users); do
    ssh gmdadmin@$i 'sudo mkgroup $j; sudo useradd -c "POSITIVA - USER - $j" -g $j -m $j ; echo $j:#c3c0muser2019# | sudo chpasswd; sudo pwdadm -c $j'
  done
done
