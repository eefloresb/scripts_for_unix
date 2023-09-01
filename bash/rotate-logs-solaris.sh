#!/bin/sh
export PATH=/sbin:/bin:/usr/sbin/:/usr/bin
xDirectory="/var/audit /var/.audit"
xMail="/var/mail"
COMPRESS=xz

rename_and_compress_old_logs(){
    for i in $xDirectory; do
    if [[ -d $i ]]; then
        cd $i
            for file in $(find . -name "[0-9]*.$(hostname)"); do
            echo "archivo $file comprimido de /var/audit en $(date +%y%m%d-%H:%m)" >> /var/tmp/logrotate_audit.log
                timestamp=$(date +%y-%m-%d-%H:%m)
                newfile="$file-$timestamp.xz"
                $COMPRESS -c $file > $newfile
                cat /dev/null > $file
            done
    fi
    done
}

delete_old_compress_log(){
    for i in $xDirectory; do
        if [[ -d $i ]]; then
            echo "archivos eliminados después de 7 días en fecha $(date +%y%m%d-%H:%m)" /var/tmp/logrotate_audit.log
            cd $i
            rm -rfv $(find . -mtime +15 -name "[0-9]*.$(hostname)-[0-9]*.xz") 1>> /var/tmp/logrotate_audit.log
        fi
    done
}

_clean_mail(){
cd $xMail
for i in *; do
        echo "archivo $i comprimido de /var/mail el $(date +%y%m%d-%H:%m)" >> /var/tmp/logrotate_audit.log
        $COMPRESS -c $i > $i-$(date +%y-%m-%d).xz
        cat /dev/null > $i
done
}

_delete_mail(){
cd $xMail
find . -type f -mtipe +120 -name "*-[0-9][0-9]-[0-9][0-9]-[0-9][0-9].xz" | while read line; do
if [[ $line != "." ]]; then
        echo "archivo xz $line en /var/mail fue borrado el $(date +%y%m%d-%H:%m)" >> /var/tmp/logrotate_audit.log
        rm -rf $line
fi
done
}

main (){
operator=$1
case $operator in
    "renamelogs" )
        rename_and_compress_old_logs
    ;;
    "delateold" )
        delete_old_compress_log
    ;;
    "cleanmail" )
        _clean_mail
    ;;
    "deletemail" )
    _delete_mail
    ;;
esac
}

main $1
