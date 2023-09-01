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
# Configuración Crontab
#00 00 15,30 * * /script/./move-delete-hpux-mount.sh deleteaud
#00 00 27 * * /script/./move-delete-hpux-mount.sh cleanmail
#00 00 27 6,12 * /script/./move-delete-hpux-mount.sh deletmail
#00 00 27 3,6,9,12 * /script/./move-delete-hpux-mount.sh copysyslog
#00 00 28 6,12 * /script/./move-delete-hpux-mount.sh deletesyslog

#!/bin/sh
xMail=/var/mail
xadm=/var/adm
xruta=/var/.audit
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
        if [[ ! -d $xruta/logs/$i ]]; then
            mkdir -p $xruta/logs/$i
        fi
    done
    _stop_services
    for i in `find $xadm -type d -name "syslog" -o -name "cron"`; do
                if [[ -d $i ]]; then
                    cd $i
                fi
                for j in `find . -type f -name "*.log" -o -name "OLDlog" -o -name "log"`; do
                    gzip -c $j > "$xruta/logs/${i##/*/}/$j-$(date +%y%m%d-%R).gz"
                    echo "archivo $xadm/${i##/*/}/$j fue comprimido en fecha:$(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
                    cat /dev/null > $j
                done
    done
    _start_services
}
_delete_syslog(){
cd $xadm/logs/
find . -type f -mtime +180 -name "*-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]:[0-9][0-9].gz" | while read line; do
    if [[ $line != "." ]]; then
        echo "archivo ${line} ubicado en $xadm/syslog/ en fecha:$(date +%y%m%d-%R) fue borrado" >> /var/tmp/logrotate_audit.log
        rm -rf $line
    fi
done
}

_del_audtrail(){
cd $xruta
find . -type d -mtime +15 -name "AuditBackup_*" -o -name "audfile*" -o -name "audtrail.*" | while read line; do
    if [[ $line != "." ]]; then
        echo "directorio borrado $line en $xruta con fecha:$(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
        rm -rf $line
    fi
done
}

_clean_mail(){
/sbin/init.d/sendmail stop
if [[ ! -d $xruta/mail ]]; then
        mkdir -p $xruta/mail
fi
cd $xMail
for i in *; do
        echo "archivo $i comprimido de /var/mail con destino $xruta $(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
        gzip -c $i > $xruta/mail/$i-$(date +%y%m%d-%R).gz
        cat /dev/null > $i
done
 /sbin/init.d/sendmail start
}

_delete_mail(){
cd $xruta/mail
find . -type f -mtime +180 -name "*-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]:[0-9][0-9].gz" | while read line; do
if [[ $line != "." ]]; then
        echo "archivo gzip $line en $ruta/mail fue borrado $(date +%y%m%d-%R)" >> /var/tmp/logrotate_audit.log
        rm -rf $line
fi
done
}

main(){
operator=$1
case "$operator" in
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
