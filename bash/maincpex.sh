#!/bin/bash
# Author: Sarav AK - aksarav@middlewareinventory.com
# Date: 2 June 2019
#
#

# Ejecutar un script de manera remota con permiso sudo

source ./password.sh
while read line; do
        # SCP - copy the script file from Current Directory to Remote Server 
        #sshpass -p$rmtpasswrd scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no create_user_with_sudo.sh $rmtuname@$line:/tmp/create_user_with_sudo.sh
        sshpass -f $filepasswd scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no create_user_with_sudo.sh $rmtuname@$line:/tmp/create_user_with_sudo.sh
        
        # Take Rest for 5 Seconds
        sleep 5

        # SSH to remote Server  and Execute a Command [ Invoke the Script ] 
        #sshpass -p$rmtpasswrd ssh   -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $rmtuname@$line "echo Tuadoo4u | sudo bash /tmp/create_user_with_sudo.sh"
        sshpass -f $filepasswd ssh   -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $rmtuname@$line "echo Tuadoo4u | sudo bash /tmp/create_user_with_sudo.sh"
done<server_lists.txt
