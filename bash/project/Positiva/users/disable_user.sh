#!/bin/bash 
USER="EDWIN ENRIQUE FLORES BAUTISTA"
declare -a vector;
declare -i suma=0;
declare -a user;
declare -i contador=0;
OS=$(uname)
PATHPASSWD="/etc/passwd"
_convert_string_to_vector(){
    for i in $USER; do 
        vector[$contador]=$i
        contador=$contador+1
    done
}

_find_user_in_file(){
    for (( j=0; j<${#vector[@]}; j++ )); do
        if ((j>=4)); then
            echo ${vector[3]}|fold -w1 | while read line; do 
                $user[0]=$line
                break;
                done

        fi
    done 
}

_convert_string_to_vector
echo ${vector[0]}
echo ${vector[1]}
echo ${vector[2]}
echo ${vector[3]}
echo ${#vector[@]}
