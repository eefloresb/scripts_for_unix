#Arquitecto y Autor: arengifo@canvia.com
#Soporte y Mantenimiento: eflores@canvia.com
#Version 3.0
#Actualizado al 18/05/2023
#license: gplv3

OS=$(uname)
export PATH=$PATH:/usr/sbin:/sbin

__get_dev_orig()
{
  local device devpath number
  device=$1
  if [ -L "$device" ]
  then
    device=$(readlink $device)
  fi
  if echo $device | grep -q "mapper"
  then
    devpath=$(echo $device | cut -d / -f 4)
    number=$(dmsetup ls | grep "^$devpath[[:blank:]]" | sed -e "s/, */:/g" | cut -d : -f 2 | tr -d ')')
    echo "dm-$number"
  else
    basename $device
  fi
}

__oslevel()
{
  if [ $OS = "Linux" ]
  then
    if [ -f $OS_FILE ]
    then
      DISTRO=$(grep -w ID $OS_FILE | cut -d = -f 2 | tr -d '"' | tr a-z A-Z)
      LEVEL=$(grep -w VERSION_ID $OS_FILE | cut -d = -f 2 | tr -d '"')
      echo -n "$DISTRO $LEVEL"
    elif [ -f $SUSE_REL_FILE ]
    then
      if grep -qi "enterprise" $SUSE_REL_FILE
      then
        DISTRO="SLES"
      elif grep -qi "opensuse" $SUSE_REL_FILE
      then
        DISTRO="OPENSUSE"
      fi
      LEVEL=$(grep "^VERSION.*=" $SUSE_REL_FILE | cut -d = -f 2 | tr -d ' ')
      echo -n "$DISTRO $LEVEL"
    elif [ -f $RH_REL_FILE ]
    then
      if grep -qi "red.*hat.*enterprise" $RH_REL_FILE
      then
        DISTRO="RHEL"
      elif grep -qi "centos" $RH_REL_FILE
      then
        DISTRO="CENTOS"
      fi
      LEVEL=$(grep -oE '([[:digit:]]\.?)+' $RH_REL_FILE)
      echo -n "$DISTRO $LEVEL"
    elif [ -f $DEBIAN_REL_FILE ]
    then
      LEVEL=$(grep -oE '([[:digit:]]\.?)+' $DEBIAN_REL_FILE)
      if [ -n "$LEVEL" ]
      then
        DISTRO="DEBIAN"
      else
        if which lsb_release > /dev/null 2>&1
        then
          DISTRO="UBUNTU"
          LEVEL=$(lsb_release -sd  | grep -oE '([[:digit:]]\.?)+')
        fi
      fi
      echo -n "$DISTRO $LEVEL"
    fi
  fi  
}

__dm2lv()
{
  local device=$1 num mapper
  if echo $device | grep -q "\/dm-[0-9]"
  then
    num=$(echo $device | cut -d - -f 2)
    mapper="/dev/$(dmsetup ls | grep -E "(:|, *)${num}\)" | awk '{ print $1 }' | tr - /)"
    echo $mapper
  else
    echo $device
  fi
}

__get_asm_info()
{
  local asmdev dm asmsize
  cat /dev/null > $ASMINFO
  grep "asm" $BLKID | awk '{ print $1 }' | tr -d : |
  while read asmdev
  do
    dm=$(__get_dev_orig $asmdev)
    asmsize=$(grep -w $dm /proc/partitions | awk '{ print $3 }')
    asmsize=$((($asmsize*100/1024)/100))
    echo $asmdev,asm,$asmsize,N/A >> $ASMINFO
  done
}

__get_sw_info()
{
  local swdev dm swsize
  cat /dev/null > $SWINFO
  grep "swap" $BLKID | awk '{ print $1 }' | tr -d : |
  while read swdev
  do
    dm=$(__get_dev_orig $swdev)
    swsize=$(grep -w $dm /proc/partitions | awk '{ print $3 }')
    swsize=$((($swsize*100/1024)/100))
    echo $swdev,swap,$swsize,N/A >> $SWINFO
  done
}

__get_lvm_info()
{
  local vg pvs lvs tmp_pvs tmp_vgs tmp_lvs
  cat /dev/null > $LVMINFO
  tmp_pvs=$(mktemp)
  tmp_vgs=$(mktemp)
  tmp_lvs=$(mktemp)
  vgs 2> /dev/null | tail -n +2 | awk '{ print $1 }' > $tmp_vgs
  pvs 2> /dev/null | tail -n +2 | awk '{ print $1,$2 }'  | cut -d / -f 3 > $tmp_pvs
  lvs 2> /dev/null | tail -n +2 | awk '{ print $1,$2 }' > $tmp_lvs
  for vg in $(cat $tmp_vgs)
  do
    pvs=$(grep -w $vg $tmp_pvs | awk '{ print $1 }' | tr '\n' : | sed -e "s/:$//g")
    lvs=$(grep -w $vg $tmp_lvs | awk '{ print $1 }' | tr '\n' : | sed -e "s/:$//g")
    echo -e "$vg\t$pvs\t$lvs" >> $LVMINFO
  done
  rm -f $tmp_pvs $tmp_vgs $tmp_lvs
}

__get_fs_info()
{
  cat /dev/null > $FSINFO
  local dev mp size free
  df -lPTB M | grep -vE "^Filesystem|tmpfs" | awk '{ print $1,$7,$3,$5 }' |
  while read dev mp size free
  do
    [ -L $dev ] && dev=$(__dm2lv $(readlink $dev))
    size=$(echo $size | tr -d M)
    free=$(echo $free | tr -d M)
    echo $dev,$mp,$size,$free >> $FSINFO
  done
}

__get_dev_use()
{
  local device vg lv args n devsize
  if [ -n "$2" ]
  then
    vg=$1
    lv=$2
  else
    device=$(basename $1)
  fi
  # LVM
  if [ -n "$vg" ] && [ -n "$lv" ]
  then
    #
    # Filesystem
    if grep -wq "$vg[-/]$lv" $FSINFO
    then
      args=$(grep -w "$vg[-/]$lv" $FSINFO | head -1 | cut -d , -f 2-)
      echo "$vg,$lv,$args"
    #
    # Swap device
    elif grep -wq "$vg[-/]$lv" $SWINFO
    then
      args=$(grep -w "$vg[-/]$lv" $SWINFO | head -1 | cut -d , -f 2-)
      echo "$vg,$lv,$args"
    #
    # ASM device
    elif grep -wq "$vg[-/]$lv" $ASMINFO
    then
      args=$(grep -w "$vg[-/]$lv" $ASMINFO | head -1 | cut -d , -f 2-)
      echo "$vg,$lv,$args"
    #
    # No use
    else
      devsize=$(grep -w $(basename $(readlink /dev/$vg/$lv)) /proc/partitions | awk '{ print $3 }')
      devsize=$((($devsize*100/1024)/100))
      echo "$vg,$lv,no use,$devsize,N/A"
    fi
  # Disco o particion nativa
  elif echo $device | grep -qE "(xv|[sv])d[a-z]*"
  then
    #
    # Filesystem
    if grep -wq $device $FSINFO
    then
      args=$(grep -w $device $FSINFO | head -1 | cut -d , -f 2-)
      n=$(basename $device | tr -d '[a-z]')
      devbase=$(echo $device | tr -d '[0-9]')
      echo "$devbase,p${n},$args"
    #
    # Swap device
    elif grep -wq $device $SWINFO
    then
      args=$(grep -w $device $SWINFO | head -1 | cut -d , -f 2-)
      n=$(basename $device | tr -d '[a-z]')
      devbase=$(echo $device | tr -d '[0-9]')
      echo "$devbase,p${n},$args"
    #
    # ASM device
    elif grep -wq $device $ASMINFO
    then
      args=$(grep -w $device $ASMINFO | head -1 | cut -d , -f 2-)
      n=$(basename $device | tr -d '[a-z]')
      devbase=$(echo $device | tr -d '[0-9]')
      echo "$devbase,p${n},$args"
    #
    # No use
    else
      n=$(basename $device | tr -d '[a-z]')
      devbase=$(echo $device | tr -d '[0-9]')
      devsize=$(grep -w $device /proc/partitions | awk '{ print $3 }')
      devsize=$((($devsize*100/1024)/100))
      if [ -z "$n" ]
      then
        if ! grep -q "[[:blank:]]${devbase}[0-9][0-9]*" /proc/partitions
        then
          echo "$devbase,N/A,no use,$devsize,N/A"
        fi
      else
        echo "$devbase,p${n},no use,$devsize,N/A"
      fi
    fi
  fi
}

__get_all_disks()
{
  grep -E " (xv|[sv])d[a-z]*$" /proc/partitions | sort -n -k1 -k2 | cat -n | awk '{ print $5,$1 }'
}

__listall()
{
  OSLEVEL=$(__oslevel)
  local diskdev disknum vg lvs lv usage
  __get_all_disks |
  while read diskdev disknum
  do
    grep "${diskdev}[0-9]*" /proc/partitions | awk '{ print $4 }' |
    while read blkdev
    do
      scsi_id=$(ls /sys/block/$diskdev/device/scsi_device 2> /dev/null | cut -d : -f 3)
      disksize=$(grep -w $diskdev /proc/partitions | awk '{ print $3 }')
      disksize=$((($disksize*100/1024)/100))
      diskname="Hard disk $disknum"
      #
      # Physical Volume de LVM
      if grep -qE "([[:blank:]]|:)${blkdev}(:|[[:blank:]])" $LVMINFO
      then
        vg=$(grep -E "([[:blank:]]|:)${blkdev}(:|[[:blank:]])" $LVMINFO | awk '{ print $1 }')
        for i_vg in $vg
        do
          lvs=$(grep -w $i_vg $LVMINFO | awk '{ print $3 }')
          IFS=":"
          for lv in $lvs
          do
            usage=$(__get_dev_use $i_vg $lv)
            echo $SERVERNAME,$OSLEVEL,$usage,$diskname,$disksize,$scsi_id >> $RESULT1
          done
        done
        unset IFS
      # Dispositivos de discos nativos (sda1, xvda3, sdb, etc...)
      else
        usage=$(__get_dev_use $blkdev)
        if [ -n "$usage" ]
        then
          echo $SERVERNAME,$OSLEVEL,$usage,$diskname,$disksize,$scsi_id >> $RESULT1
        fi
      #
      fi
    done
  done
  IFS=","
  while read res_servername res_so res_vg res_lv res_mp res_devsize res_devfree res_disk res_disksize res_scsi_id
  do
    if ! grep -q ",$res_vg,$res_lv," $RESULT2
    then
      echo "$res_servername,$res_so,$res_vg,$res_lv,$res_mp,$res_devsize,$res_devfree,$res_disk,$res_disksize,$res_scsi_id" >> $RESULT2
    else
      if ! grep -q ",$res_vg,$res_lv," $RESULT2
      then
        echo "$res_servername,$res_so,$res_vg,$res_lv,$res_mp,$res_devsize,$res_devfree,,," >> $RESULT2
      else
        if ! grep -q ",$res_vg,.*,.*,.*,.*,$res_disk," $RESULT2
        then
          echo "$res_servername,$res_so,$res_vg,,,,,$res_disk,$res_disksize,$res_scsi_id" >> $RESULT2
        fi
      fi
    fi
  done < $RESULT1
  cat $RESULT2
}

#####################################################################################
#!/usr/bin/ksh
AIX()
{
for SERVER_PHOTO_SO in $(hostname -s)

do
echo '-----------------hostname -----------------------------'
hostname

echo ''

echo '-----------------uname -a-----------------------------'
uname -a

echo ''

echo '-----------------oslevel -s-----------------------------'

oslevel -s
echo ''

echo '----------------- Kernel bits ---------------------------'

bootinfo -K

echo ''

echo '----------------- smtctl --------------------------------'

smtctl

echo ''

echo '------------------ who ---------------------------------'

who

echo ''

echo '-----------------uptime-----------------------------'

uptime
echo ''

echo '-----------------date-----------------------------'

date
echo ''


echo '--------------------LISTA DE INTERFACES DE RED-----------------------------------'

netstat -ri

echo ''

echo '-----------------CONFIGURACION DE IPs--------------------------------'

ifconfig -a

echo ''

echo '--------------------TABLA de RUTEO-----------------------------------'

netstat -rn

echo ''

echo '--------------TOTAL DE MEMORIA VIRTUAL -----------------'

lsps -s

echo ''


echo '--------------DETALLE DE MEMORIA VIRTUAL -----------------'

lsps -a

echo ''


echo '-------------------INFORMACION SOBRE VIRTUAL MACHINE-----------------------'

vmstat 1 5

echo ''

echo '--------------------df 'Sin NFS'---------------------------------'

/usr/sysv/bin/df -vl

echo ''

# echo '--------------------df 'Con NFS'---------------------------------'
# 
# df -P

echo ''

echo '--------------------mount---------------------------------'

mount

echo ''

echo '------------------- Filesystems automaticos -----------------'

cat /etc/filesystems

echo ''


echo '--------------------DETALLE FILESYSTEM---------------------------------'

lsfs

echo ''


echo '----------------CONFIGURACION DE PVs---------------------------'

lspv -u

echo ''

echo '---------------- CONFIGURACION DE PVs 2 -----------------------'

lspv

echo ''

echo '----------------TAMANO Y SERIAL DE PVs---------------------------'

for DISKSIZE in $(lspv | awk '{print $1}'); do echo ${DISKSIZE}; bootinfo -s ${DISKSIZE}; lscfg -vpl ${DISKSIZE} | egrep "(${DISKSIZE}|Serial Number)"; echo; done

echo ''


echo '----------------VGs Activos--------------------------'

lsvg -o

echo ''


echo '----------------VGs Activos - Detalles1--------------------------'

lsvg -o | lsvg -i

echo ''

echo '----------------VGs Activos - Detalles2--------------------------'

lsvg -o | lsvg -i -l

echo ''

echo '----------------VGs Activos - Detalles3--------------------------'

lsvg -o | lsvg -i -p

echo ''


echo '------------------REPORTE DE SERVICIOS------------------------------'

lssrc -a
echo ''


echo '------------------FIRMWARE------------------------------'

lsmcode -c

echo ''


echo '------------------CONFIGURACION DE DISPOSITIVOS 1-----------------------'

lscfg -vp

echo ''

echo '----------------- FCSTAT de tarjetas ------------------------------------'

lsdev | grep -i fcs | awk '{print $1}' | while read fc; do echo "==================================== $fc ===================================="; fcstat $fc;  echo "==================================== $fc ===================================="; done

echo ''

echo '----------------- Parametros de SCSI ----------------------------------'

lsdev | grep -i fscsi | cut -d " " -f1 | while read fscsi; do echo $fscsi; lsattr -El $fscsi; echo; done

echo ''

echo '----------------- Parametros de discos ----------------------------------'

lspv | cut -d " " -f1 | while read disk; do echo $disk; echo; lsattr -El $disk; echo; done

echo '----------------- Parametros de FC ----------------------------------'

lsdev | grep -i fcs| cut -d " " -f1 | while read fc; do echo $fc; lsattr -El $fc; echo; done

echo ''


echo ''

echo '----------------- Bloqueos en el VG ----------------------------------'

lsvg | while read vg; do lvmo -a -v $vg; echo; done

echo ''



echo '------------------CONFIGURACION DE DISPOSITIVOS 2-----------------------'

lsdev

echo ''


echo '------------------INFORMACION DEL LPAR------------------------------'
lparstat -i
echo ''

echo '------------------INFORMACION DEL SISTEMA------------------------------'

prtconf

echo ''


echo '------------------INFORMACION PCI------------------------------'

lsslot -c pci

echo ''

echo '------------------Usuarios------------------------------'

cat /etc/passwd

echo ''

echo '------------------Claves------------------------------'
cat /etc/security/passwd
echo ''

echo '------------------Grupos------------------------------'

cat /etc/group

echo ''

echo '------------------ limits-------------------------------'

cat /etc/security/limits | grep -v '^*' | grep -v ^$

echo ''


echo '------------------Hosts------------------------------'

cat /etc/hosts

echo ''

echo '-------------------------crontab------------------------'

crontab -l

echo ''

echo '------------------Procesos------------------------------'

ps -fea

echo ''


echo '------------------Procesos ORACLE------------------------------'

ps -ef | grep ora | grep -v grep

echo ''


echo '------------------Procesos JAVA------------------------------'

ps -ef | grep java | grep -v grep

echo ''


echo '------------------Procesos DB2------------------------------'

ps -ef | grep db | grep -v grep

echo ''


echo '------------------Procesos SAP------------------------------'

ps -ef | grep sap | grep -v grep

echo ''


echo '------------------VARIABLES------------------------------'

env

echo ''

echo '------------------ETC ENVIRONMENT------------------------------'

egrep -v '(^#|^$)' /etc/environment

echo ''


echo '------------------FILESYSTEMS EXPORTADOS------------------------------'

showmount -e
netstat -na | grep 2049

echo ''

echo '------------------CONEXIONES netstat tcp ------------------------------'

netstat -Aan | grep ' tcp | tcp4 ' 

echo ''

echo '------------------CONEXIONES netstat LISTEN ------------------------------'

netstat -Aan | grep -i "Listen"

echo ''

echo '------------------ NETSVC -------------------------------------------------'

cat /etc/netsvc.conf | grep -v ^#

echo ''

echo '------------------ RESOLV -------------------------------------------------'

cat /etc/resolv.conf | grep -v ^#

echo ''

echo '------------------fget_config------------------------------'
fget_config -Av
echo ''

echo '------------------mpio_get_config------------------------------'
mpio_get_config -A
echo ''

echo '------------------datapath------------------------------'
datapath query device
echo ''

echo '----------------- pcpmath------------------------------'
pcmpath query device
echo
pcmpath query version
echo ''

echo '------------------ XIV ---------------------------------'
xiv_devlist
echo ''

echo '------------------ XIV Detalles -------------------------'
xiv_devlist -o device,serial,lun,vol_name,vol_id,size,xiv_host
echo ''

echo '------------------lspath------------------------------'

lspath
echo ''

echo '------------------lspath------------------------------'
odmget -q "attribute=unique_id" CuAt
echo ''

echo '------------------ITM------------------------------'

/opt/IBM/ITM/bin/cinfo -r
echo ''

echo '------------------NIMSOFT------------------------------'

/opt/nimsoft/bin/niminit status
echo ''

echo '-----------------ERRPT------------------------------'
errpt
errpt -a
echo ''

echo '----------------- BOOTLIST--------------------------'
bootlist -o -m normal
echo ''

echo '------------------ IPL -----------------------------'
ipl_varyon -i
echo ''

echo '-------------------- HMC ---------------------------'
lsrsrc IBM.MCP
echo ''

echo '------------------- CRONTABS -------------------------'
ls -1 /var/spool/cron/crontabs | while read job; do echo "File: $job";cat $job; echo; done
echo ''

echo '-------------------- INITTAB --------------------------'
cat /etc/inittab
echo ''

echo ' ------------------- TAPE -----------------------------'
lsdev -Cc tape
echo ''

echo '-------------------- FILESET ---------------------------'
lslpp -L 
echo ''

echo ''

echo '-------------------- LVMO ---------------------------'
lsvg | while read vg; do echo; lvmo -v $vg -a; done
echo ''

echo ''

echo '-------------------- VMO ---------------------------'
vmo -a
echo ''

echo ''

echo '-------------------- netstat ---------------------------'
netstat -v
echo ''

echo ''

done 
}

#####################################################################################
Linux ()
{
  
for SERVER_PHOTO_SO in $(hostname -s)
do
echo '----------------- START hostname -----------------------------'
hostname -f
echo '------------------- END hostname -----------------------------'
echo ''

echo "---------------------------------- START uptime ----------------------------------"
uptime
echo "---------------------------------- END uptime ----------------------------------"
echo ""

echo "---------------------------------- START date ----------------------------------"
date
echo "---------------------------------- END date ----------------------------------"
echo ""

echo "---------------------------------- START /etc/modprobe.conf ----------------------------------"
cat /etc/modprobe.conf
echo "---------------------------------- END /etc/modprobe.conf ----------------------------------"
echo ""

echo "---------------------------------- START cat /etc/redhat-release | /etc/os-release ----------------------------------"
if [[ -f /etc/redhat-release ]]; then
    cat /etc/redhat-release
elif [[ -f /etc/SuSE-release ]]; then 
    cat /etc/SuSE-release
elif [[ -f /etc/os-release ]]; then
    cat /etc/os-release
else 
  echo "SO no declarado, validar el fichero /etc/release"
fi
echo "---------------------------------- END cat /etc/redhat-release | /etc/os-release ----------------------------------"
echo ""

echo "---------------------------------- START uname -a ----------------------------------"
uname -a
echo "---------------------------------- END uname -a ----------------------------------"
echo ""

# Add dmidecode to 18/05/23

echo "---------------------------------- START dmidecode ----------------------------------"
dmidecode --t 1
echo "---------------------------------- END dmidecode ----------------------------------"
echo ""

echo "---------------------------------- START /etc/passwd ----------------------------------"
cat /etc/passwd
echo "---------------------------------- END /etc/passwd ----------------------------------"
echo ""

echo "---------------------------------- START /etc/shadow ----------------------------------"
cat /etc/shadow
echo "---------------------------------- END /etc/shadow ----------------------------------"
echo ""

echo "---------------------------------- START /etc/group ----------------------------------"
cat /etc/group
echo "---------------------------------- END /etc/group ----------------------------------"
echo ""

echo "---------------------------------- START /etc/sudoers ----------------------------------"
cat /etc/sudoers
echo "---------------------------------- END /etc/sudoers ----------------------------------"
echo ""

#Add 18/05/23
echo "---------------------------------- START /etc/sudoers.d/ ----------------------------------"
ls -C1 /etc/sudoers.d/* | while read file; do echo "File: $file"; cat $file | grep -v ^#; echo; done
echo "---------------------------------- END /etc/sudoers.d/ ----------------------------------"
echo ""

echo "---------------------------------- START who -r ----------------------------------"
who -r
echo "---------------------------------- END who -r ----------------------------------"
echo ""

echo "---------------------------------- START cat /etc/hosts ----------------------------------"
egrep -v '(^#|^$)' /etc/hosts
echo "---------------------------------- END cat /etc/hosts ----------------------------------"
echo ""

echo "---------------------------------- START crontab -l ----------------------------------"
crontab -l
echo "---------------------------------- END crontab -l ----------------------------------"
echo ''

echo "---------------------------------- START for users crontab ----------------------------------"
ls -C1 /var/spool/cron/* | while read job; do echo "File: $job";cat $job; echo; done
echo "---------------------------------- END for users crontab ----------------------------------"
echo ''

echo "---------------------------------- START /usr/sbin/showmount -e ----------------------------------"
/usr/sbin/showmount -e
echo "---------------------------------- END /usr/sbin/showmount -e ----------------------------------"
echo ""

echo "---------------------------------- START ps aux ----------------------------------"
ps aux
echo "---------------------------------- END ps aux ----------------------------------"
echo ""

echo "---------------------------------- START /etc/fstab ----------------------------------"
cat /etc/fstab
echo ""
echo "---------------------------------- END /etc/fstab ----------------------------------"

echo "---------------------------------- START lsblk ----------------------------------"
lsblk
echo "---------------------------------- END lsblk ----------------------------------"
echo

echo "---------------------------------- START multipath ----------------------------------"
multipath -ll
echo "---------------------------------- END multipath ----------------------------------"
echo ""

echo "---------------------------------- START /etc/multipath.conf ----------------------------------"
cat /etc/multipath.conf
echo "---------------------------------- END /etc/multipath.conf ----------------------------------"
echo ""

echo "---------------------------------- START UDEV -------------------------------"
ls -1 /etc/udev/rules.d/ | while read file; do echo $file; cat /etc/udev/rules.d/$file; echo; done
echo "---------------------------------- END UDEV---------------------------------"
echo ""

echo "---------------------------------- START mount ----------------------------------"
mount
echo "---------------------------------- END mount ----------------------------------"
echo ""

echo "---------------------------------- START pvs ----------------------------------"
pvs
echo "---------------------------------- END pvs ----------------------------------"
echo ""

echo "---------------------------------- START /usr/sbin/pvdisplay ----------------------------------"
/usr/sbin/pvdisplay
echo "---------------------------------- END /usr/sbin/pvdisplay ----------------------------------"
echo ""

echo "---------------------------------- START vgs ----------------------------------"
vgs
echo "---------------------------------- END vgs ----------------------------------"
echo ""

echo "---------------------------------- START /usr/sbin/vgdisplay ----------------------------------"
/usr/sbin/vgdisplay
echo "---------------------------------- END /usr/sbin/vgdisplay ----------------------------------"
echo ""

echo "---------------------------------- START lvs ----------------------------------"
lvs
echo "---------------------------------- END lvs ----------------------------------"
echo ""

echo "---------------------------------- START /usr/sbin/lvdisplay ----------------------------------"
/usr/sbin/lvdisplay
echo "---------------------------------- END /usr/sbin/lvdisplay ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/ifconfig ----------------------------------"
/sbin/ifconfig
echo "---------------------------------- END /sbin/ifconfig ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/ip with alias----------------------------------"
/sbin/ip a
echo "---------------------------------- END /sbin/ip with alias----------------------------------"
echo ''

echo "---------------------------------- START /sbin/ips ----------------------------------"
ls -C1 /etc/sysconfig/network-scripts/ifcfg-* | while read netw; do echo "file: $netw"; cat $netw; echo; done
echo
echo "---------------------------------- END /sbin/ips ----------------------------------"
echo ""

echo "---------------------------------- START SELINUX----------------------------------"
sestatus
echo "---------------------------------- END SELINUX ----------------------------------"
echo ""

echo "---------------------------------- START IPTABLES ----------------------------------"
iptables -L -nvx
echo
echo ""
iptables -t nat -L -nvx
echo "---------------------------------- END IPTABLES----------------------------------"
echo ""

echo "---------------------------------- START SAVE IPTABLES ----------------------------------"
iptables-save
echo ""
echo "---------------------------------- END SAVE IPTABLES----------------------------------"
echo ""


echo "---------------------------------- START FIREWALLD----------------------------------"
systemctl status firewalld
echo
echo "status firewall-cmd: " firewall-cmd --state
echo "---------------------------------- END FIREWALLD----------------------------------"
echo ""

echo "---------------------------------- START CONFIG FIREWALLD----------------------------------"
echo "List the ports and zones"
firewall-cmd --list-all
echo "---------------------------------- END CONFIG FIREWALLD----------------------------------"
echo ""

echo "---------------------------------- START /sbin/route -n ----------------------------------"
/sbin/route -n
echo "---------------------------------- END /sbin/route -n ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/route -n ----------------------------------"
ls /etc/sysconfig/network-scripts/route-* | while read net; do cat $net; echo; done
echo "---------------------------------- END /sbin/route -n ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/bonding ----------------------------------"
ls /proc/net/bonding/bond* | while read bond; do echo $bond; cat $bond; echo; done
echo "---------------------------------- END /sbin/bonding ----------------------------------"
echo ""

echo "---------------------------------- START free ----------------------------------"
free
echo "---------------------------------- END free ----------------------------------"
echo ""

echo "---------------------------------- START cat /proc/swaps ----------------------------------"
cat /proc/swaps
echo "---------------------------------- END cat /proc/swaps ----------------------------------"
echo ""

echo "---------------------------------- START cat /proc/cpuinfo ----------------------------------"
cat /proc/cpuinfo
echo "---------------------------------- END cat /proc/cpuinfo ----------------------------------"
echo ""

echo "---------------------------------- MAPEO DISCOS Y FILESYSTEMS ----------------------------------"
LVMINFO=$(mktemp)
FSINFO=$(mktemp)
SWINFO=$(mktemp)
ASMINFO=$(mktemp)
BLKID=$(mktemp)
OS=$(uname)
SUSE_REL_FILE="/etc/SuSE-release"
RH_REL_FILE="/etc/redhat-release"
DEBIAN__REL_FILE="/etc/debian_version"
OS_FILE="/etc/os-release"
SERVERNAME=$(hostname -s)
RESULT1=$(mktemp)
RESULT2=$(mktemp)
blkid | sed -r -e "s/(^.*:).*(TYPE=\"[[:alnum:]]*\")/\1 \2/g" | tr -d '":' | sed -e "s/TYPE=//g" > $BLKID
__get_lvm_info
__get_fs_info
__get_sw_info
__get_asm_info
__listall
rm -f $LVMINFO $FSINFO $BLKID $SWINFO $ASMINFO $RESULT1 $RESULT2
echo "---------------------------------- END MAPEO DISCOS Y FILESYSTEMS ----------------------------------"
echo ""

echo "---------------------------------- START df -Pl 'Sin NFS' ----------------------------------"
df -Pl
echo "---------------------------------- END df -Pl ----------------------------------"
echo ""

echo "---------------------------------- START Permisos de filesystem ----------------------------------"
for FS in $(df -Plh | awk '{print $6}' | egrep -v '^(Mounted|/dev)'); do ls -ld $FS; done
echo "---------------------------------- END Permisos de filesystem ----------------------------------"
echo ""

echo "---------------------------------- START cat /etc/resolv.conf ----------------------------------"
cat /etc/resolv.conf
echo "---------------------------------- END cat /etc/resolv.conf ----------------------------------"
echo ""

echo "---------------------------------- START netstat -tupan | egrep (LISTEN|^udp) ----------------------------------"
netstat -tupan | egrep "(LISTEN|^udp)"
echo "---------------------------------- END netstat -tupan | egrep (LISTEN|^udp) ----------------------------------"
echo ""

echo "---------------------------------- START netstat -ntplow | egrep (LISTEN|^tcp) ----------------------------------"
netstat -ntplow | egrep "(LISTEN|^tcp)"
echo "---------------------------------- END netstat -ntplow | egrep (LISTEN|^tcp) ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/chkconfig --list ----------------------------------"
/sbin/chkconfig --list
echo "---------------------------------- END /sbin/chkconfig --list ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/lspci -v ----------------------------------"
/sbin/lspci -v
echo "---------------------------------- END /sbin/lspci -v ----------------------------------"
echo ""

echo "---------------------------------- START /etc/profile -------------------------------"
cat /etc/profile
echo "---------------------------------- END /etc/profile ---------------------------------"
echo ""

echo "---------------------------------- START /sbin/lssci ----------------------------------"
/bin/lsscsi
/sbin/lssci
/usr/bin/lsscsi
echo "---------------------------------- END /sbin/lssci ----------------------------------"
echo ""

echo "---------------------------------- START ITM ----------------------------------"
/opt/IBM/ITM/bin/cinfo -r
echo "---------------------------------- END ITM ----------------------------------"
echo ""

echo "---------------------------------- START NIMSOFT----------------------------------"
/etc/init.d/nimbus status
echo "---------------------------------- END NIMSOFT----------------------------------"
echo ""

echo "---------------------------------- START CUPS ----------------------------------"
cat /etc/cups/cupsd.conf
echo "---------------------------------- END CUPS ----------------------------------"
echo ""

echo "---------------------------------- START PRINTERS----------------------------------"
cat /etc/cups/printers.conf
echo "---------------------------------- END PRINTERS ----------------------------------"
echo ""

echo "---------------------------------- START Informacion de SAMBA -------------------------------"
cat /etc/samba/smb.conf
echo "---------------------------------- END Informacion de SAMBA ---------------------------------"
echo ""

echo "---------------------------------- START Informacion de Kerberos -------------------------------"
cat /etc/krb5.conf
echo "---------------------------------- END Informacion de Kerberos ---------------------------------"
echo ""

echo "---------------------------------- START Informacion de SSSD  -------------------------------"
cat /etc/sssd/sssd.conf
echo "---------------------------------- END Informacion de SSSD ---------------------------------"
echo ""

echo "---------------------------------- START Informacion de PAM  -------------------------------"
echo "file: /etc/pam.d/password-auth"
cat /etc/pam.d/password-auth
echo "----------------------------------------------------------------------------------------------"
echo "file: /etc/pam.d/system-auth"
cat /etc/pam.d/system-auth
echo "----------------------------------------------------------------------------------------------"
echo "file: /etc/pam.d/common-account"
cat /etc/pam.d/common-account
echo "----------------------------------------------------------------------------------------------"
echo "file: /etc/pam.d/common-auth"
cat /etc/pam.d/common-auth
echo "----------------------------------------------------------------------------------------------"
echo "file: /etc/pam.d/common-session"
cat /etc/pam.d/common-session
echo "---------------------------------- END Informacion de PAM  -------------------------------"
echo ""

echo "---------------------------------- START SIZE ----------------------------------"
 ls -d /sys/block/sd*/device/scsi_device/* |awk -F '[/]' '{print $4,"- SCSI",$7}' | awk '{print $1}'| while read disk; do lsblk | grep -w $disk; done
echo "---------------------------------- END SIZE -------------------------------------"
echo ""

echo "----------------------------------- START SNMP ----------------------------------"
cat /etc/snmp/snmpd.conf
echo "------------------------------------ END SNMP -----------------------------------"
echo ""

echo "----------------------------------- START SSHD ----------------------------------"
cat /etc/ssh/sshd_config
echo "------------------------------------ END SSHD -----------------------------------"
echo ""

echo "---------------------------------- START LIMITS----------------------------------"
cat /etc/security/limits.conf | grep -v '^*' | grep -v "^$"
echo "---------------------------------- END LIMITS----------------------------------"
echo ""

echo "---------------------------------- LISTA DE SERVICIOS INSTALADOS - SERVICES COMMAND ----------------------------------"
service --status-all
echo "---------------------------------- END LISTA DE SERVICIOS INSTALADOS - SERVICES COMMAND -------------------------------"
echo ""


echo "---------------------------------- LISTA DE SERVICIOS INSTALADOS - SYSTEMCTL COMMAND ----------------------------------"
systemctl list-unit-files --type service --all
echo "---------------------------------- END LISTA DE SERVICIOS INSTALADOS - SYSTEMCTL COMMAND -------------------------------"
echo ""

echo "---------------------------------- LISTA DE SERVICIOS ACTIVOS - SYSTEMCTL COMMAND ----------------------------------"
/usr/bin/systemctl --type=service --state=running
echo "---------------------------------- END LISTA DE SERVICIOS ACTIVOS - SYSTEMCTL COMMAND -------------------------------"
echo ""

echo "---------------------------------- START GRUB----------------------------------"
echo "file: /boot/grub/menu.lst"
cat /boot/grub/menu.lst
echo "file: /etc/default/grub"
cat /etc/default/grub
echo "---------------------------------- END GRUB----------------------------------"
echo ""

echo "---------------------------------- BEGIN GRUB LIST FILESYSTEMS -------------------------------------"
# Añadido por eliminación del /grub/* te permite reconocer porque no carga el SO
 __list_files(){
    GRUB=$1
    cd $GRUB
    echo "list of files de from boot|boot efi"
    echo "----------------------------"
    ls -RC1 *
  }
  declare -a vector=($(__oslevel))
  OS="${vector[0]}"
  declare -i VERSION="${vector[1]%.*}"
  echo "List files in /boot to grub|grub2"
  __list_files /boot/
  echo ""
  echo "list of content from grub to $OS $VERSION"
  echo "-----------------------------------------"
  if [[ $OS == "RHEL" || $OS == "CENTOS" ]]; then
      if (( $VERSION <= 6 )); then
        cat /boot/grub/menu.lst
      else
        cat /boot/grub2/grub.cfg
      fi
  elif [[ $OS == "DEBIAN" || $OS == "UBUNTU" ]]; then
      if (( $VERSION <= 8  )); then
        cat /boot/grub/menu.lst
      else
      cat /boot/grub2/grub.cfg
      fi
  elif [[ $OS == "SLES" ]]; then
    if (( $VERSION <= 11 )); then 
      cat /boot/grub/menu.lst
    else 
      cat /boot/grub2/grub.cfg
    fi
  fi
echo "--------------------------------- END GRUB LIST FILESYSTEMS -------------------------------------------"
echo ""
done 
}
#####################################################################################
SunOS(){
for SERVER_PHOTO_SO in $(hostname)
do 
echo "----------------- START hostname -----------------------------"
hostname
echo "------------------- END hostname -----------------------------"
echo ""

echo "---------------------------------- START uptime ----------------------------------"
uptime
echo "---------------------------------- END uptime ----------------------------------"
echo ""

echo "---------------------------------- START date ----------------------------------"
date
echo "---------------------------------- END date ----------------------------------"
echo ""

echo "---------------------------------- START uname -a ----------------------------------"
uname -a
echo "---------------------------------- END uname -a ----------------------------------"
echo ""

echo "---------------------------------- START ISSUE ----------------------------------"
cat /etc/issue
echo "---------------------------------- END ISSUE ----------------------------------"
echo ""

echo "---------------------------------- START /etc/passwd ----------------------------------"
cat /etc/passwd
echo "---------------------------------- END /etc/passwd ----------------------------------"
echo ""

echo "---------------------------------- START /etc/shadow ----------------------------------"
cat /etc/shadow
echo "---------------------------------- END /etc/shadow ----------------------------------"
echo ""

echo "---------------------------------- START /etc/group ----------------------------------"
cat /etc/group
echo "---------------------------------- END /etc/group ----------------------------------"
echo ""

echo "---------------------------------- START /etc/sudoers ----------------------------------"
cat /etc/sudoers
echo "---------------------------------- END /etc/sudoers ----------------------------------"
echo ""

echo "---------------------------------- START who -r ----------------------------------"
who -a
echo "---------------------------------- END who -r ----------------------------------"
echo ""

echo "---------------------------------- START cat /etc/hosts ----------------------------------"
egrep -v '(^#|^$)' /etc/hosts
echo "---------------------------------- END cat /etc/hosts ----------------------------------"
echo ""

echo "---------------------------------- START crontab -l ----------------------------------"
crontab -l
echo "---------------------------------- END crontab -l ----------------------------------"
echo ''
echo "---------------------------------- START /usr/sbin/showmount -e ----------------------------------"
/usr/sbin/showmount -e
echo "---------------------------------- END /usr/sbin/showmount -e ----------------------------------"
echo ""

echo "---------------------------------- START ps aux ----------------------------------"
ps aux
echo "---------------------------------- END ps aux ----------------------------------"
echo ""

echo "---------------------- START Captura la lista de paquetes instalados--------------"
pkginfo
echo "---------------------- END Captura la lista de paquetes instalados--------------"
echo ""

echo "---------------------------------- START /etc/fstab ----------------------------------"
cat /etc/vfstab
echo ""
echo "---------------------------------- END /etc/fstab ----------------------------------"

echo "---------------------------------- START DISPLAYING INFORMATION ABOUT ALL STORAGES POOLS OR A SPECIFIC POOL --------------------------------"
zpool list
echo "---------------------------------- END DISPLAYING INFORMATION ABOUT ALL STORAGES POOLS OR A SPECIFIC POOL --------------------------------"
echo ""

echo "---------------------------------- START DISPLAYING POOL DEVICES BY PHISICAL LOCATIONS --------------------------------"
zpool list | tail +2 | awk '{print $1}' | while read line;do zpool status -l $line ;done 
echo "---------------------------------- START DISPLAYING POOL DEVICES BY PHISICAL LOCATIONS --------------------------------"
echo ""

echo "---------------------------------- START LISTING VIRTUAL DEVICE I/O --------------------------------"
zpool iostat -v 
echo "---------------------------------- START LISTING VIRTUAL DEVICE I/O --------------------------------"
echo ""

echo "---------------------------------- START mount ----------------------------------"
mount
echo "---------------------------------- END mount ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/ifconfig ----------------------------------"
/usr/sbin/ifconfig -a 
echo "---------------------------------- END /sbin/ifconfig ----------------------------------"
echo ""

echo "---------------------------------- START /sbin/route -n ----------------------------------"
netstat -nr
echo "---------------------------------- END /sbin/route -n ----------------------------------"
echo ""

echo "---------------------------------- START free ----------------------------------"
echo ::memstat|mdb -k
echo "---------------------------------- END free ----------------------------------"
echo ""

echo "---------------------------------- START Captura información del kernel ----------------------------------"
sysdef
echo "---------------------------------- END Captura información del kernel ----------------------------------"
echo ""

echo "---------------------------------- START df -Pl 'Sin NFS' ----------------------------------"
df -Pl
echo "---------------------------------- END df -Pl ----------------------------------"
echo ""

echo "---------------------------------- START df -h ----------------------------------"
df -h
echo "---------------------------------- END df -h ----------------------------------"
echo ""

echo "---------------------------------- START df -h 'Puntos de Montaje' ----------------------------------"
df -h
echo "---------------------------------- END df -h ----------------------------------"
echo ""

echo "---------------------------------- START type of permission to filesystem ----------------------------------"
for FS in $(df -Plh | awk '{print $6}' | egrep -v '^(Mounted|/dev)'); do ls -ld $FS; done
echo "---------------------------------- END type of permission to filesystem ----------------------------------"
echo ""

echo "---------------------------------- START cat /etc/resolv.conf ----------------------------------"
cat /etc/resolv.conf
echo "---------------------------------- END cat /etc/resolv.conf ----------------------------------"
echo ""

echo "---------------------------------- START cat /etc/nsswitch.conf ----------------------------------"
cat /etc/nsswitch.conf
echo "---------------------------------- END cat /etc/nsswitch.conf ----------------------------------"
echo ""

echo "---------------------------------- START List Ports  ----------------------------------"
# https://www.oracle.com/technetwork/systems/security/pcp-149863.txt
__get_all_listen_ports(){
    if [ $# -lt 1 ]
    then
    echo >&2 "usage: $0 [-p PORT] [-P PID] [-a ALL ] (Wildcards OK)"
    exit 1
    fi
    while getopts :p:P:a opt
    do
    case "${opt}" in
    p ) port=${OPTARG};;
    P ) pid=${OPTARG};;
    a ) all=all;;
    [?]) # unknown flag
    echo >&2 "usage: $0 [-p PORT] [-P PID] [-a ALL ] (Wildcards OK) "
    exit 1;;
    esac
    done
    shift `expr $OPTIND - 1`
    if [ $port ]
    then
    # Enter the port number, get the PID
    #
    port=${OPTARG}
    echo "PID\tProcess Name and Port"
    echo "_________________________________________________________"
    for proc in `ptree -a | grep -v ptree | awk '{print $1};'`
    do
    result=`pfiles $proc 2> /dev/null| grep "port: $port"`
    if [ ! -z "$result" ]
    then
    program=`ps -fo comm -p $proc | tail -1`
    echo "$proc\t$program\t$port\n$result"
    echo "_________________________________________________________"
    fi
    done
    elif [ $pid ]
    then
    # Enter the PID, get the port
    #
    pid=$OPTARG
    # Print out the information
    echo "PID\tProcess Name and Port"
    echo "_________________________________________________________"
    for proc in `ptree -a | grep -v ptree | grep $pid| awk '{print $1};'`
    do
    result=`pfiles $proc 2> /dev/null| grep port:`
    if [ ! -z "$result" ]
    then
    program=`ps -fo comm -p $pid | tail -1`
    echo "$proc\t$program\n$result"
    echo "_________________________________________________________"
    fi
    done
    elif [ $all ]
    then
    # Show all PIDs, Ports and Peers
    #
    echo "PID\tProcess Name and Port"
    echo "_________________________________________________________"
    for pid in `ptree -a | grep -v ptree |sort -n | awk '{print $1};'`
    do
    out=`pfiles $pid 2>/dev/null| grep "port:"`
    if [ ! -z "$out" ]
    then
    name=`ps -fo comm -p $pid | tail -1`
    echo "$pid\t$name\n$out"
    echo "_________________________________________________________"
    fi
    done
    fi
}
__get_all_listen_ports -a ALL
echo "---------------------------------- END List Ports  ----------------------------------"
echo ""

echo "---------------------------------- START CUPS ----------------------------------"
cat /etc/cups/cupsd.conf
echo "---------------------------------- END CUPS ----------------------------------"
echo ""

echo "---------------------------------- START FIND NUMBER PROCESS ----------------------------------"
psrinfo -p 
echo "---------------------------------- END FIND NUMBER PROCESS ----------------------------------"
echo ""

echo "---------------------------------- START PROCESS Version ----------------------------------"
psrinfo -pv
echo "---------------------------------- END FIND NUMBER PROCESS ----------------------------------"
echo ""

echo "---------------------------------- START /etc/system ----------------------------------"
cat /etc/system
echo "---------------------------------- END /etc/system ----------------------------------"

echo "---------------------------------- START LIST STATUS SERVICES ----------------------------------"
svcs -a
echo "---------------------------------- END LIST STATUS SERVICES ----------------------------------"

echo "---------------------------------- START LIST STATUS CONTROLLED BY INETD ----------------------------------"
inetadm
echo "---------------------------------- END LIST STATUS CONTROLLED BY INETD ----------------------------------"

done

}
#####################################################################################

if [ "$OS" = "AIX" ]
then
  AIX
elif [ "$OS" = "Linux" ]
then
  Linux
elif [ "$OS" = "SunOS" ]
then
 SunOS 
fi
