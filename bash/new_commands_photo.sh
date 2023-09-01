###############################################################
# Script:
# Uso:
# Fecha:
# Version: modificado del script original de COT
# Autor:
###############################################################
SISTEMA2="$(hostname)$(date +%d%m%y).rtf"
SISTEMA1=$(hostname)

echo '-----------------------INFORMACION DE SISTEMA------------------------' > /tmp/"$SISTEMA2"
echo SERVIDOR: $SISTEMA1 >> /tmp/"$SISTEMA2"
uname -a  >> /tmp/"$SISTEMA2"
cat /etc/issue   >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"

echo '-----------------------INFORMACION DE CPU----------------------------' >> /tmp/"$SISTEMA2"
mpstat -P ALL >> /tmp/"$SISTEMA2"
cat /proc/cpuinfo >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"

echo '-----------------UTILIZACION DEL CPU---------------------------------' >> /tmp/"$SISTEMA2"
iostat 1 2 -x >> /tmp/"$SISTEMA2"
sar -u 3 5 >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '-------------------ANCHO DE BANDA DEL CPU----------------------------' >> /tmp/"$SISTEMA2"
###vmstat 1 5 >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"

echo '----------------INFORMACION DE TARJETAS PCI--------------' >> /tmp/"$SISTEMA2"
/sbin/lspci >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"

echo '-----------------CONFIGURACION DE IP--------------------------------' >> /tmp/"$SISTEMA2"
ifconfig >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '-----------------CONFIGURACION DE TARJETAS DE RED--------------------------------' >> /tmp/"$SISTEMA2"
cat /etc/sysconfig/network-scripts/ifcfg-* >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"
echo '-----------------CONFIGURACION DE RUTAS PERMANENTES--------------------------------' >> /tmp/"$SISTEMA2"
cat /etc/sysconfig/network-scripts/route-* >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"
echo '--------------------TABLA de RUTEO-----------------------------------' >> /tmp/"$SISTEMA2"
netstat -rn >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"


echo '---------------------INFORMACION DE MEMORIA--------------------------' >> /tmp/"$SISTEMA2"
free >> /tmp/"$SISTEMA2"
cat /proc/meminfo >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '---------------REPORTE DE UTILIZACION DE MEMORIA---------------------' >> /tmp/"$SISTEMA2"
sar -r  2 3 >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"


echo '-------------------------FILESYSTEMS---------------------------------' >> /tmp/"$SISTEMA2"
df -h >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '-------------------------FDISK---------------------------------' >> /tmp/"$SISTEMA2"
/sbin/fdisk -l >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '----------------CONFIGURACION DE LVM(VOLUMENES FISICOS)--------------' >> /tmp/"$SISTEMA2"
pvdisplay -v >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '----------------CONFIGURACION DE LVM(VOLUMENES DE GRUPO)-------------' >> /tmp/"$SISTEMA2"
vgdisplay -v >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '----------------CONFIGURACION DE LVM(VOLUMENES LOGICOS)--------------' >> /tmp/"$SISTEMA2"
lvdisplay -v >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"


echo ' ' >> /tmp/"$SISTEMA2"
echo '--------------------NSSWITCH.CONF-----------------------------' >> /tmp/"$SISTEMA2"
cat /etc/nsswitch.conf  >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '--------------------RESOLV.CONF-----------------------------' >> /tmp/"$SISTEMA2"
cat /etc/resolv.conf  >> /tmp/"$SISTEMA2"

echo ' ' >> /tmp/"$SISTEMA2"
echo '------------------PARAMETROS DEL KERNEL------------------------------' >> /tmp/"$SISTEMA2"
sysctl -a >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '----------------------LOG DEL SISTEMA--------------------------------' >> /tmp/"$SISTEMA2"
tail -200 /var/log/messages >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '--------------------------DMESG--------------------------------------' >> /tmp/"$SISTEMA2"
dmesg >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '' >> /tmp/"$SISTEMA2"


echo '----------------------USUARIOS DEL SISTEMA---------------------------' >> /tmp/"$SISTEMA2"
cat /etc/passwd >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '-------------------GRUPOS DEL SISTEMA--------------------------------' >> /tmp/"$SISTEMA2"
cat /etc/group >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '---------------------------FSTAB-------------------------------------' >> /tmp/"$SISTEMA2"
cat /etc/fstab >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '-----------------------------HOSTS-----------------------------------' >> /tmp/"$SISTEMA2"
cat /etc/hosts >> /tmp/"$SISTEMA2"
echo "          "
 


echo ' ' >> /tmp/"$SISTEMA2"
echo '--------------------Procesos del sistema-----------------------------' >> /tmp/"$SISTEMA2"
ps -ef  >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '----------------------Procesos ORACLE--------------------------------' >> /tmp/"$SISTEMA2"
ps -ef | grep -i ora >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '----------------------Procesos JAVA----------------------------------' >> /tmp/"$SISTEMA2"
ps -ef | grep -i java >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '---------------------Procesos CONCURRENTES---------------------------' >> /tmp/"$SISTEMA2"
ps -ef | grep -i fnd >> /tmp/"$SISTEMA2"
echo ' ' >> /tmp/"$SISTEMA2"
echo '------------------PAQUETES INSTALADOS--------------------------------' >> /tmp/"$SISTEMA2"
rpm -qa >> /tmp/"$SISTEMA2"


echo '------------------REPORTE DE SERVICIOS-------------------------------' >> /tmp/"$SISTEMA2"
chkconfig --list >> /tmp/"$SISTEMA2"
cat /etc/services >> /tmp/"$SISTEMA2"
echo "          "


echo "SE GENERO EL ARCHIVO /tmp/"$SISTEMA2" "

#gzip /tmp/"$SISTEMA2"

#echo "Se adjunta reporte mensual de configuracion" | mailx -s "Reporte Mensual $SISTEMA1" -a /tmp/"$SISTEMA2".gz jrodriguezv@gmd.com.pe