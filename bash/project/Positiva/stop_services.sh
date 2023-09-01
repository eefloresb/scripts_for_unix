#!/bin/bash
#Autor: eflores@canvia.com 
#License: Gplv2
#129 ==> Error01
DIRBIN="/opt/IBM/IHS/bin"

declare -i count = 0
_get_Process=(){
    ps -fea | grep httpd | grep -v grep | while read line; do 
        count=$count+1;
    done 
    echo "$count"
}
_robot_analize(){

}

_start_process(){
    if adminctl start && apachectl start; then 
        echo "0"
    else
        exit 132
    fi
}

_start_service(){
    if [[ -d $DIRBIN ]]; then
        cd $DIRBIN
        count=$(_get_Process)
        if (( $count = 0 )); then 
                _start_process
                if [[ $? == "0" ]]; then 
                    exit 0
                else 
                    exit 130
                fi
        else 
                echo "exists process runned in $HOSTNAME server"
                echo "the application is the preview started "
                exit 0
        fi

    else
        echo "send mail to sysadmin@canvia.com, the start process of $0 not initialited"
        exit 0
    fi
}

_kill_process(){
    if adminctl stop && apachectl stop; then 
        echo "0"
    else
        exit 131
    fi
}

_stop_service(){
    if [[ -d $DIRBIN ]]; then
        cd $DIRBIN
        count=$(_get_Process)
        if (( $count > 0 )); then 
             _kill_process
            if [[ $? == "0" ]]; then 
                exit 0
            else 
                exit 129 
            fi
        else 
            echo "not process declare in $HOSTNAME server"
            echo "the application is stopped"
            exit 0
        fi
    else
        echo "the application is stopped"
        exit 0
    fi
}

_main(){
process=$1
    case $process in 
        start)
            _start_service;;
        stop)
            _stop_service;;
    esac
}

_main $1
