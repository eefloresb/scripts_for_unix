#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Edwin Enrique Flores Bautista
# Email: eflores@canvia.com

# Permite mover un archivo entre particiones, no disponible porque se pudo incrementar el disco

# cron cada 6 horas
#/sbin/init.d/cron start | /sbin/init.d/cron stop
#/sbin/init.d/syslogd start | /sbin/init.d/syslogd stop
#/sbin/init.d/sendmail start | /sbin/init.d/sendmail stop
#!/bin/sh
xOrigendir=/var/.audit
xRemotedir=/audit
xMail=/var/mail
xMailaud=/audit/mail
xSyslog=/var/adm/
xdirSyslog="syslog cron"

_stop_services(){
    /sbin/init.d/cron stop
    /sbin/init.d/syslogd stop
}

_start_services(){
    /sbin/init.d/cron start
    /sbin/init.d/syslogd start
}

_copy_remote_syslog(){
    for i in $xdirSyslog; do
        if [[ ! -d /audit/logs/$i ]]; then
            mkdir -p /audit/logs/$i
        fi
    done
    _stop_services
    for i in `find /var/adm/ -type d -name "syslog" -o -name "cron"`; do
                if [[ -d $i ]]; then
                cd $i
                fi
                for j in `find . -type f -name "*.log" -o -name "OLDlog" -o -name "log"`; do
                    gzip -c $j > /audit/logs/${i##/*/}/$j-$(date +%y%m%d-%R).gz
                    echo "archivo /var/adm/${i##/*/}/$j fue comprimido con destino /audit/logs/${i##/*/} en fecha/hora $(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
                    cat /dev/null > $j
                done
    done
    _start_services
}
_copy_remote_syslog


_delete_syslog(){
cd /audit/logs/
find . -type f -mtime +180 -name "*.gz" | while read line; do
    if [[ $line != "." ]]; then
        echo "archivo ${line} ubicado en /audit/logs/ en fecha:$(date +%y%m%d-%R) fue borrado" >> /var/tmp/logrotate_audit.log
        rm -rf $line
    fi
done
}

_copy_remove_audtrail(){
xOrigendir=/var/.audit
cd $xOrigendir
for i in `find . -type d -name "AuditBackup_*" -o -name "audfile*" -o -name "audtrail.*"`; do
    xultimo=$(ls -lt|head -n 2 | tail -1|awk '{print $9}')
    if [[ ${i} != "./${xultimo}" ]]; then
        cp -r $i $xRemotedir/.
        rm -rf $i
        echo "directorio $i fue copiado al directorio /audit en fecha:$(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
    fi
done
}

_del_audtrail(){
cd $xRemotedir
find . -type d -mtime +15 -name "AuditBackup_*" -o -name "audfile*" -o -name "audtrail.*" | while read line; do
    if [[ $line != "." ]]; then
        echo "directorio borrado $line en $xRemotedir en $(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
        rm -rf $line
    fi
done
}

_clean_mail(){
if [[ ! -d /audit/mail ]]; then
    mkdir /audit/mail
fi
/sbin/init.d/sendmail stop
cd $xMail
for i in *; do
        echo "archivo $i comprimido de /var/mail con destino /audit/mail $(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
        gzip -c $i > /audit/mail/$i-$(date +%y-%m-%d).gz
        cat /dev/null > $i
done
/sbin/init.d/sendmail start
}

_delete_mail(){
cd $xMailaud
find . -type f -mtime +120 -name "*-[0-9][0-9]-[0-9][0-9]-[0-9][0-9].gz" | while read line; do
if [[ $line != "." ]]; then
        echo "archivo gzip $line en /var/mail fue borrado $(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
        rm -rf $line
fi
done
}

main(){
operator=$1
case "$operator" in
    "copyaud")
        _copy_remove_audtrail
    ;;
    "deleteaud")
        _del_audtrail
    ;;
    "cleanmail")
        _clean_mail
    ;;
    "deletmail")
        _delete_mail
    ;;
    "copysyslog")
    _copy_remote_syslog
    ;;
    "deletesyslog")
    _delete_syslog
esac
}

main $1
