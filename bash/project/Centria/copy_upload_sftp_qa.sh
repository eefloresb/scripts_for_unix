#!/bin/bash 
PORT="22"
REMOTE="190.116.5.24"
mkdir /var/tmp/temporal
TEMPDIR="/var/tmp/temporal"

_sftp_upload(){
local USER=$1
local FILE=$2
local DESTCOPY=/nfshomedesa/$USER/$3
local PASSWORD=$4
sshpass -p $PASSWORD sftp -oPort=$PORT $USER@$REMOTE:$DESTCOPY<<EOF
put $FILE
EOF
}

if [[ -d /home/SCOTIA/FACTORING/AESA/IN ]]; then 
    cd /home/SCOTIA/FACTORING/AESA/IN
    user="usftp834"
    tempdir="IN"
    password="MPfG2WtA"
    ls -C1|while read line; do 
        _sftp_upload $user $line $tempdir $password
        mv -v $line $TEMPDIR
    done
fi
if [[ -d /home/SCOTIA/FACTORING/AESA/OUT ]]; then 
    cd /home/SCOTIA/FACTORING/AESA/OUT
    user="usftp834"
    tempdir="OUT"
    password="MPfG2WtA"
    ls -C1|while read line; do 
        _sftp_upload $user $line $tempdir $password
        mv -v $line $TEMPDIR
    done
fi
if [[ -d /home/SCOTIA/FACTORING/AESA/BKP ]]; then 
    cd /home/SCOTIA/FACTORING/AESA/BKP
    user="usftp834"
    tempdir="BKP"
    password="MPfG2WtA"
    ls -C1|while read line; do 
        _sftp_upload $user $line $tempdir $password
        mv -v $line $TEMPDIR
    done
fi


if [[ -d /home/SCOTIA/FACTORING/AESA/IN ]]; then
    cd /home/SCOTIA/FACTORING/AESA/IN
    user="usftp373"
    tempdir="IN"
    password="zMmCI3yd"
    ls -C1|while read line; do
        _sftp_upload $user $line $tempdir $password
        mv -v $line $TEMPDIR
    done
fi
if [[ -d /home/SCOTIA/FACTORING/AESA/OUT ]]; then
    cd /home/SCOTIA/FACTORING/AESA/OUT
    user="usftp373"
    tempdir="OUT"
    password="zMmCI3yd"
    ls -C1|while read line; do
        _sftp_upload $user $line $tempdir $password
        mv -v $line $TEMPDIR
    done
fi
if [[ -d /home/SCOTIA/FACTORING/AESA/BKP ]]; then
    cd /home/SCOTIA/FACTORING/AESA/BKP
    user="usftp373"
    tempdir="BKP"
    password="zMmCI3yd"
    ls -C1|while read line; do
        _sftp_upload $user $line $tempdir $password
        mv -v $line $TEMPDIR
    done
fi

