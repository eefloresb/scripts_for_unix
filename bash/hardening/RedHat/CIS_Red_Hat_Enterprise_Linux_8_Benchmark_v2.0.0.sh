#!/bin/bash

echo -e "##############################################################################"
echo -e "Checking Hardening on: $(hostname)"
echo -e "Date: $(date +"%m-%d-%y")"
echo -e "##############################################################################"
echo " "
#1.1.1.1 Ensure mounting of cramfs filesystems is disabled

comando1=$(lsmod | grep cramfs)

if [ -z "$comando1" ]; then
echo -e "1.1.1.1 Ensure mounting of cramfs filesystems is disabled:\e[1;32m OK \e[0m"
else
echo -e "1.1.1.1 Ensure mounting of cramfs filesystems is disabled:\e[1;31m FAIL \e[0m"
fi

#1.1.1.2 Ensure mounting of squashfs filesystems is disabled
comando2=$(lsmod | grep squashfs)

if [ -z "$comando2" ]; then
echo -e "1.1.1.2 Ensure mounting of squashfs filesystems is disabled:\e[1;32m OK \e[0m"
else
echo -e "1.1.1.2 Ensure mounting of squashfs filesystems is disabled:\e[1;31m FAIL \e[0m"
fi

#1.1.1.3 Ensure mounting of udf filesystems is disabled

comando3=$(lsmod | grep udf)

if [ -z "$comando3" ]; then
echo -e "1.1.1.3 Ensure mounting of udf filesystems is disabled:\e[1;32m OK \e[0m"
else
echo -e "1.1.1.3 Ensure mounting of udf filesystems is disabled:\e[1;31m FAIL \e[0m"
fi

#1.1.2 Confifure /tmp 
#1.1.2.1 Ensure /tmp is a separate partition - Automated 
comando4a=$(findmnt --kernel /tmp)
comando4b=$(systemctl is-enabled tmp.mount)

if [[ ! -z "$comando4a" && ! -z "$comando4b" ]]; then
echo -e "1.1.2.1 Ensure /tmp is a separate partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.2.1 Ensure /tmp is a separate partition:\e[1;31m FAIL \e[0m"
fi

#1.1.2.2 Ensure nodev option set on /tmp partition - Automated 
comando5=$(findmnt --kernel /tmp | grep nodev)

if [ ! -z "$comando5" ]; then
echo -e "1.1.2.2 Ensure nodev option set on /tmp partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.2.2 Ensure nodev option set on /tmp partition:\e[1;31m FAIL \e[0m"
fi

#1.1.2.3 Ensure noexec option set on /tmp partition - Automated
comando6=$(findmnt --kernel /tmp | grep noexec)

if [ ! -z "$comando6" ]; then
echo -e "1.1.2.3 Ensure noexec option set on /tmp partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.2.3 Ensure noexec option set on /tmp partition:\e[1;31m FAIL \e[0m"
fi

#1.1.2.4 Ensure nosuid option set on /tmp partition - Automated
comando7=$(findmnt --kernel /tmp| grep nosuid)
if [ ! -z "$comando7" ]; then
echo -e "1.1.2.4 Ensure nosuid option set on /tmp partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.2.4 Ensure nosuid option set on /tmp partition:\e[1;31m FAIL \e[0m"
fi

#1.1.3 Configure /var 
#1.1.3.1 Ensuse separate partition exists for /var
comando8=$(findmnt --kernel /var)
if [ ! -z "$comando8" ]; then
echo -e "1.1.3.1 Ensure separate partition exists for /var:\e[1;32m OK \e[0m"
else
echo -e "1.1.3.1 Ensure separate partition exists for /var:\e[1;31m FAIL \e[0m"
fi

#1.1.3.2 Ensure nodev option set on /var partition - Automated
comando9=$(findmnt --kernel /var | grep nodev)

if [ ! -z "$comando9" ]; then
echo -e "1.1.3.2 Ensure nodev option set on /var partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.3.2 Ensure nodev option set on /var partition:\e[1;31m FAIL \e[0m"
fi

#1.1.3.3 Ensure noexec option set on /var partition - Automated
comando10=$(findmnt --kernel /var | grep noexec)

if [ ! -z "$comando10" ]; then
echo -e "1.1.3.3 Ensure noexec option set on /var partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.3.3 Ensure noexec option set on /var partition:\e[1;31m FAIL \e[0m"
fi

#1.1.3.4 Ensure nosuid option set on /var partition - Automated
comando11=$(findmnt --kernel /var| grep nosuid)
if [ ! -z "$comando11" ]; then
echo -e "1.1.3.4 Ensure nosuid option set on /var partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.3.4 Ensure nosuid option set on /var partition:\e[1;31m FAIL \e[0m"
fi

#1.1.4 Configure /var/tmp
#1.1.4.1 Ensuse separate partition exists for /var/tmp
comando12=$(findmnt --kernel /var/tmp)
if [ ! -z "$comando12" ]; then
echo -e "1.1.4.1 Ensure separate partition exists for /var/tmp:\e[1;32m OK \e[0m"
else
echo -e "1.1.4.1 Ensure separate partition exists for /var/tmp:\e[1;31m FAIL \e[0m"
fi

#1.1.4.2 Ensure nodev option set on /var/tmp partition - Automated
comando13=$(findmnt --kernel /var/tmp | grep nodev)

if [ ! -z "$comando13" ]; then
echo -e "1.1.4.2 Ensure nodev option set on /var/tmp partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.4.2 Ensure nodev option set on /var/tmp partition:\e[1;31m FAIL \e[0m"
fi

#1.1.4.3 Ensure noexec option set on /var/tmp partition - Automated
comando14=$(findmnt --kernel /var/tmp | grep noexec)

if [ ! -z "$comando14" ]; then
echo -e "1.1.4.3 Ensure noexec option set on /var/tmp partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.4.3 Ensure noexec option set on /var/tmp partition:\e[1;31m FAIL \e[0m"
fi

#1.1.4.4 Ensure nosuid option set on /var/tmp partition - Automated
comando15=$(findmnt --kernel /var/tmp| grep nosuid)
if [ ! -z "$comando15" ]; then
echo -e "1.1.4.4 Ensure nosuid option set on /var/tmp partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.4.4 Ensure nosuid option set on /var/tmp partition:\e[1;31m FAIL \e[0m"
fi

#1.1.5 Ensure separate partition exists for /var/log
#1.1.5.1 Ensuse separate partition exists for /var/log
comando16=$(findmnt --kernel /var/log)
if [ ! -z "$comando16" ]; then
echo -e "1.1.5.1 Ensure separate partition exists for /var/log:\e[1;32m OK \e[0m"
else
echo -e "1.1.5.1 Ensure separate partition exists for /var/log:\e[1;31m FAIL \e[0m"
fi

#1.1.5.2 Ensure nodev option set on /var/log partition - Automated
comando17=$(findmnt --kernel /var/log | grep nodev)
if [ ! -z "$comando17" ]; then
echo -e "1.1.5.2 Ensure nodev option set on /var/log partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.5.2 Ensure nodev option set on /var/log partition:\e[1;31m FAIL \e[0m"
fi

#1.1.5.3 Ensure noexec option set on /var/log partition - Automated
comando18=$(findmnt --kernel /var/log | grep noexec)
if [ ! -z "$comando18" ]; then
echo -e "1.1.5.3 Ensure noexec option set on /var/log partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.5.3 Ensure noexec option set on /var/log partition:\e[1;31m FAIL \e[0m"
fi

#1.1.5.4 Ensure nosuid option set on /var/log partition - Automated
comando19=$(findmnt --kernel /var/log| grep nosuid)
if [ ! -z "$comando19" ]; then
echo -e "1.1.5.4 Ensure nosuid option set on /var/log partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.5.4 Ensure nosuid option set on /var/log partition:\e[1;31m FAIL \e[0m"
fi

#1.1.6 Ensure separate partition exists for /var/log/audit
#1.1.6.1 Ensuse separate partition exists for /var/log/audit
comando20=$(findmnt --kernel /var/log/audit)
if [ ! -z "$comando20" ]; then
echo -e "1.1.6.1 Ensure separate partition exists for /var/log/audit:\e[1;32m OK \e[0m"
else
echo -e "1.1.6.1 Ensure separate partition exists for /var/log/audit:\e[1;31m FAIL \e[0m"
fi

#1.1.6.2 Ensure nodev option set on /var/log/audit partition - Automated
comando21=$(findmnt --kernel /var/log/audit | grep nodev)
if [ ! -z "$comando21" ]; then
echo -e "1.1.6.2 Ensure nodev option set on /var/log/audit partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.6.2 Ensure nodev option set on /var/log/audit partition:\e[1;31m FAIL \e[0m"
fi

#1.1.6.3 Ensure noexec option set on /var/log/audit partition - Automated
comando22=$(findmnt --kernel /var/log/audit | grep noexec)
if [ ! -z "$comando22" ]; then
echo -e "1.1.6.3 Ensure noexec option set on /var/log/audit partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.6.3 Ensure noexec option set on /var/log/audit partition:\e[1;31m FAIL \e[0m"
fi

#1.1.6.4 Ensure nosuid option set on /var/log/audit partition - Automated
comando23=$(findmnt --kernel /var/log/audit| grep nosuid)
if [ ! -z "$comando23" ]; then
echo -e "1.1.6.4 Ensure nosuid option set on /var/log/audit partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.6.4 Ensure nosuid option set on /var/log/audit partition:\e[1;31m FAIL \e[0m"
fi

#1.1.7 Ensure separate partition exists for /home
#1.1.7.1 Ensuse separate partition exists for /var/home
comando24=$(findmnt --kernel /home)
if [ ! -z "$comando24" ]; then
echo -e "1.1.7.1 Ensure separate partition exists for /home:\e[1;32m OK \e[0m"
else
echo -e "1.1.7.1 Ensure separate partition exists for /home:\e[1;31m FAIL \e[0m"
fi

#1.1.7.2 Ensure nodev option set on /home partition - Automated
comando25=$(findmnt --kernel /home | grep nodev)
if [ ! -z "$comando25" ]; then
echo -e "1.1.7.2 Ensure nodev option set on /home partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.7.2 Ensure nodev option set on /home partition:\e[1;31m FAIL \e[0m"
fi

#1.1.7.3 Ensure nosuid option set on /home partition - Automated
comando26=$(findmnt --kernel /home| grep nosuid)
if [ ! -z "$comando26" ]; then
echo -e "1.1.7.3 Ensure nosuid option set on /home partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.7.3 Ensure nosuid option set on /home partition:\e[1;31m FAIL \e[0m"
fi

#1.1.7.4 Ensure usrquota option set on /home partition (Automated)
comando27=$(findmnt --kernel /home | grep usrquota)
if [ ! -z $comando27 ]; then
echo -e "1.1.7.4 Ensure usrquota option set on /home partition:\e[1;32m OK \e[0m"
else 
echo -e "1.1.7.4 Ensure usrquota option set on /home partition:\e[1;31m FAIL \e[0m"
fi

#1.1.7.5 Ensure grpquota option set on /home partition (Automated)
comando28=$(findmnt --kernel /home | grep grpquota)
if [ ! -z $comando28 ]; then
echo -e "1.1.7.5 Ensure grpquota option set on /home partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.7.5 Ensure grpquota option set on /home partition:\e[1;31m FAIL \e[0m"
fi

#1.1.8 Configure /dev/shm
#1.1.8.1 Ensure nodev option set on /dev/shm partition (Automated)
comando29=$(mount | grep -E '\s/dev/shm\s' | grep -v nodev)
if [ ! -z $comando29 ]; then
echo -e "1.1.8.1 Ensure nodev option set on /dev/shm partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.8.1 Ensure nodev option set on /dev/shm partition:\e[1;31m FAIL \e[0m"
fi

#1.1.8.2 Ensure noexec option set on /dev/shm partition (Automated)
comando30=$(findmnt --kernel /dev/shm | grep noexec)
if [ ! -z $comando30 ]; then
echo -e "1.1.8.2 Ensure noexec option set on /dev/shm partition:\e[1;32m OK \e[0m"
else 
echo -e "1.1.8.2 Ensure noexec option set on /dev/shm partition:\e[1;31m FAIL \e[0m"  
fi

#1.1.8.3 Ensure nosuid option set on /dev/shm partition (Automated)
comando31=$(mount | grep -E '\s/dev/shm\s' | grep -v nosuid)
if [ ! -z $comando31 ]; then 
echo -e "1.1.8.3 Ensure nosuid option set on /dev/shm partition:\e[1;32m OK \e[0m"
else
echo -e "1.1.8.3 Ensure nosuid option set on /dev/shm partition:\e[1;31m FAIL \e[0m"
fi

#1.1.9 Disable Automounting ( Automated )
comando32=$(systemctl is-enabled autofs 2>&1 > /dev/null)
if [[ ! -z $comando32 || $comando32 == "Failed to get unit file state for autofs.service: No such file or directory" ]]; then 
echo -e "Disable Automounting option is:\e[1;32m OK \e[0m"
else
echo -e "Disable Automounting option is:\e[1;31m FAIL \e[0m"
fi

#1.1.10 Disable USB Storage (Automated)
comando33=$(modprobe -n -v usb-storage)
if [[ ! -z $comando33 ]]; then 
echo -e "Disable USB storage is:\e[1;32m OK \e[0m"
else
echo -e "Disable USB storage is:\e[1;31m FAIL \e[0m"
fi

#1.2 Configure Software Updates
#1.2.1 Ensure Red Hat Subscription Manager connection is configured ( Automated )
comando34=$(subscription-manager identity 2>&1 > /dev/null)

if [ "$comando34" != "This system is not yet registered. Try 'subscription-manager register --help' for more information." ]; then
echo -e "1.2.1 Ensure Red Hat Subscription Manager connection is configured:\e[1;32m OK \e[0m"
else
echo -e "1.2.1 Ensure Red Hat Subscription Manager connection is configured:\e[1;31m FAIL \e[0m"
fi

#1.2.2 Ensure GPG keys are configured (Manual)
comando35=$( 
for  RPM_PACKAGE in $(rpm -q gpg-pubkey); do 
  echo "RPM: ${RPM_PACKAGE}"
  RPM_SUMMARY=$(rpm -q --queryformat "%{SUMMARY}" "${RPM_PACKAGE}") 
  RPM_PACKAGER=$(rpm -q --queryformat "%{PACKAGER}" "${RPM_PACKAGE}")
  RPM_DATE=$(date +%Y-%m-%d -d "1970-1-1+$((0x$(rpm -q --queryformat "%{RELEASE}" "${RPM_PACKAGE}") ))sec")
  RPM_KEY_ID=$(rpm -q --queryformat "%{VERSION}" "${RPM_PACKAGE}") 
echo "Packager: ${RPM_PACKAGER}
     Summary: ${RPM_SUMMARY}
     Creation date: ${RPM_DATE}
     Key ID: ${RPM_KEY_ID};"
done
)
IFS=";"
for i in $comando35; do
echo $i
done

#1.2.3 Ensure gpgcheck is globally activated (Automated)
comando36=$(grep -P "^gpgcheck\h*=\h*[^1].*\h*$" /etc/yum.repos.d/*)
if [[ ! -z $comando36 ]]; then 
echo -e "1.2.3 Ensure gpgcheck is globally activated:\e[1;32m OK \e[0m"
else
echo -e "1.2.3 Ensure gpgcheck is globally activated:\e[1;31m FAIL \e[0m"
fi

#1.2.4 Ensure package manager repositories are configured (Manual)
dnf repolist

#1.3 Filesystem Integrity Checking
#1.3.1 Ensure AIDE is installed (Automated)
comando37=$(rpm -q aide)
if [ ! -z $comando37 ]; then 
  echo -e "1.3.1 Ensure AIDE is installed:\e[1;32m OK \e[0m"
else
  echo -e "1.3.1 Ensure AIDE is installed:\e[1;31m FAIL \e[0m"
fi

#1.3.2 Ensure filesystem integrity is regularly checked











#1.3.1 Ensure sudo is installed

comando29=$(rpm -q sudo)

if [ "$?" -eq 0 ]; then
echo -e "1.3.1 Ensure sudo is installed:\e[1;32m OK \e[0m"
else
echo -e "1.3.1 Ensure sudo is installed:\e[1;31m FAIL \e[0m"
fi

#1.3.2 Ensure sudo commands use pty

comando30=$(grep -Ei '^\s*Defaults\s+(\[^#]+,\s*)?use_pty' /etc/sudoers)

if [ "$?" -eq 0 ]; then
echo -e "1.3.2 Ensure sudo commands use pty:\e[1;32m OK \e[0m"
else
echo -e "1.3.2 Ensure sudo commands use pty:\e[1;31m FAIL \e[0m"
fi

#1.3.3 Ensure sudo log file exists

comando31=$(grep -Ei '^\s*Defaults\s+([^#]+,\s*)?logfile=' /etc/sudoers)

if [ "$?" -eq 0 ]; then
echo -e "1.3.3 Ensure sudo log file exists:\e[1;32m OK \e[0m"
else
echo -e "1.3.3 Ensure sudo log file exists:\e[1;31m FAIL \e[0m"
fi

#1.4.1 Ensure AIDE is installed

comando32=$(rpm -q aide)

if [ "$?" -eq 0 ]; then
echo -e "1.4.1 Ensure AIDE is installed:\e[1;32m OK \e[0m"
else
echo -e "1.4.1 Ensure AIDE is installed:\e[1;31m FAIL \e[0m"
fi

#1.4.2 Ensure filesystem integrity is regularly checked

comando33=$(grep -r aide /etc/cron.* /etc/crontab)

if [ "$?" -eq 0 ]; then
echo -e "1.4.2 Ensure filesystem integrity is regularly checked:\e[1;32m OK \e[0m"
else
echo -e "1.4.2 Ensure filesystem integrity is regularly checked:\e[1;31m FAIL \e[0m"
fi

#1.5.1 Ensure permissions on bootloader config are configured

comando34=$(stat /boot/grub2/grub.cfg | grep Access | head -1 | awk '{print $2}' | cut -d '/' -f2 | cut -d ')' -f1)
comando35=$(stat /boot/grub2/grubenv | grep Access | head -1 | awk '{print $2}' | cut -d '/' -f2 | cut -d ')' -f1)

if [ "$comando34" == "-rw-------" ] && [ "$comando35" == "-rw-------" ]; then
echo -e "1.5.1 Ensure permissions on bootloader config are configured:\e[1;32m OK \e[0m"
else
echo -e "1.5.1 Ensure permissions on bootloader config are configured:\e[1;31m FAIL \e[0m"
fi

#1.5.2 Ensure bootloader password is set

comando36=$(grep "^\s*GRUB2_PASSWORD" /boot/grub2/user.cfg 2>&1 > /dev/null)

if [ "$?" -eq 0 ]; then
echo -e "1.5.2 Ensure bootloader password is set:\e[1;32m OK \e[0m"
else
echo -e "1.5.2 Ensure bootloader password is set:\e[1;31m FAIL \e[0m"
fi

#1.5.3 Ensure authentication required for single user mode

comando37=$(grep /systemd-sulogin-shell /usr/lib/systemd/system/rescue.service)
comando38=$(grep /systemd-sulogin-shell /usr/lib/systemd/system/emergency.service)

if [ "$comando37" == "ExecStart=-/usr/lib/systemd/systemd-sulogin-shell rescue" ] && [ "$comando38" == "ExecStart=-/usr/lib/systemd/systemd-sulogin-shell emergency" ]; then
echo -e "1.5.3 Ensure authentication required for single user mode:\e[1;32m OK \e[0m"
else
echo -e "1.5.3 Ensure authentication required for single user mode:\e[1;31m FAIL \e[0m"
fi

#1.6.1 Ensure core dumps are restricted

comando39=$(grep "hard core" /etc/security/limits.conf)
comando40=$(sysctl fs.suid_dumpable)
comando41=$(grep "fs\.suid_dumpable" /etc/sysctl.conf /etc/sysctl.d/*)

if [ "$comando39" == "* hard core 0" ] && [ "$comando40" == "fs.suid_dumpable = 0" ] && [ "$comando41" == "fs.suid_dumpable = 0" ]; then
echo -e "1.6.1 Ensure core dumps are restricted:\e[1;32m OK \e[0m"
else
echo -e "1.6.1 Ensure core dumps are restricted:\e[1;31m FAIL \e[0m"
fi

#1.6.2 Ensure address space layout randomization (ASLR) is enabled

comando42=$(sysctl kernel.randomize_va_space)
comando43=$(grep "kernel\.randomize_va_space" /etc/sysctl.conf /etc/sysctl.d/*)

if [ "$comando42" == "kernel.randomize_va_space = 2" ] && [ "$comando43" == "kernel.randomize_va_space = 2" ]; then
echo -e "1.6.2 Ensure address space layout randomization (ASLR) is enabled:\e[1;32m OK \e[0m"
else
echo -e "1.6.2 Ensure address space layout randomization (ASLR) is enabled:\e[1;31m FAIL \e[0m"
fi

#1.7.1.1 Ensure SELinux is installed

comando44=$(rpm -q libselinux)

if [ "$?" -eq 0 ]; then
echo -e "1.7.1.1 Ensure SELinux is installed:\e[1;32m OK \e[0m"
else
echo -e "1.7.1.1 Ensure SELinux is installed:\e[1;31m FAIL \e[0m"
fi

#1.7.1.2 Ensure SELinux is not disabled in bootloader configuration

comando45=$(grep -E 'kernelopts=(\S+\s+)*(selinux=0|enforcing=0)+\b' /boot/grub2/grubenv)

if [ "$?" -eq 0 ]; then
echo -e "1.7.1.2 Ensure SELinux is not disabled in bootloader configuration:\e[1;32m OK \e[0m"
else
echo -e "1.7.1.2 Ensure SELinux is not disabled in bootloader configuration:\e[1;31m FAIL \e[0m"
fi

#1.7.1.3 Ensure SELinux policy is configured

comando46=$(grep -E '^\s*SELINUXTYPE=(targeted|mls)\b' /etc/selinux/config)

if [ "$comando46" == "SELINUXTYPE=targeted" ]; then
echo -e "1.7.1.3 Ensure SELinux policy is configured:\e[1;32m OK \e[0m"
else
echo -e "1.7.1.3 Ensure SELinux policy is configured:\e[1;31m FAIL \e[0m"
fi

#1.7.1.4 Ensure the SELinux state is enforcing

comando47=$(grep -E '^\s*SELINUX=enforcing' /etc/selinux/config)

if [ "$comando47" == "SELINUX=enforcing" ]; then
echo -e "1.7.1.4 Ensure the SELinux state is enforcing:\e[1;32m OK \e[0m"
else
echo -e "1.7.1.4 Ensure the SELinux state is enforcing:\e[1;31m FAIL \e[0m"
fi

#1.7.1.5 Ensure no unconfined services exist

comando48=$(ps -eZ | grep unconfined_service_t)

if [ -z "$comando48" ]; then
echo -e "1.7.1.5 Ensure no unconfined services exist:\e[1;32m OK \e[0m"
else
echo -e "1.7.1.5 Ensure no unconfined services exist:\e[1;31m FAIL \e[0m"
fi

#1.7.1.6 Ensure SETroubleshoot is not installed

comando49=$(rpm -q setroubleshoot)

if [ "$?" -eq 0 ]; then
echo -e "1.7.1.6 Ensure SETroubleshoot is not installed:\e[1;32m OK \e[0m"
else
echo -e "1.7.1.6 Ensure SETroubleshoot is not installed:\e[1;31m FAIL \e[0m"
fi

#1.7.1.7 Ensure the MCS Translation Service (mcstrans) is not installed

comando50=$(rpm -q mcstrans)

if [ "$?" -eq 0 ]; then
echo -e "1.7.1.7 Ensure the MCS Translation Service (mcstrans) is not installed:\e[1;32m OK \e[0m"
else
echo -e "1.7.1.7 Ensure the MCS Translation Service (mcstrans) is not installed:\e[1;31m FAIL \e[0m"
fi

#1.8.1.1 Ensure message of the day is configured properly

comando51=$(cat /etc/motd)

if [ ! -z "$comando51" ]; then
echo -e "1.8.1.1 Ensure message of the day is configured properly:\e[1;32m OK \e[0m"
else
echo -e "1.8.1.1 Ensure message of the day is configured properly:\e[1;31m FAIL \e[0m"
fi

#1.8.1.2 Ensure local login warning banner is configured properly

comando52=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue)

if [ -z "$comando52" ]; then
echo -e "1.8.1.2 Ensure local login warning banner is configured properly:\e[1;32m OK \e[0m"
else
echo -e "1.8.1.2 Ensure local login warning banner is configured properly:\e[1;31m FAIL \e[0m"
fi

#1.8.1.3 Ensure remote login warning banner is configured properly

comando53=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net)

if [ -z "$comando53" ]; then
echo -e "1.8.1.3 Ensure remote login warning banner is configured properly:\e[1;32m OK \e[0m"
else
echo -e "1.8.1.3 Ensure remote login warning banner is configured properly:\e[1;31m FAIL \e[0m"
fi

#1.8.1.4 Ensure permissions on /etc/motd are configured

comando54=$(stat /etc/motd | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando54" == "-rw-r--r-- root root" ]; then
echo -e "1.8.1.4 Ensure permissions on /etc/motd are configured:\e[1;32m OK \e[0m"
else
echo -e "1.8.1.4 Ensure permissions on /etc/motd are configured:\e[1;31m FAIL \e[0m"
fi

#1.8.1.5 Ensure permissions on /etc/issue are configured

comando55=$(stat /etc/issue | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando54" == "-rw-r--r-- root root" ]; then
echo -e "1.8.1.5 Ensure permissions on /etc/issue are configured:\e[1;32m OK \e[0m"
else
echo -e "1.8.1.5 Ensure permissions on /etc/issue are configured:\e[1;31m FAIL \e[0m"
fi

#1.8.1.6 Ensure permissions on /etc/issue.net are configured

comando56=$(stat /etc/issue.net | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando54" == "-rw-r--r-- root root" ]; then
echo -e "1.8.1.6 Ensure permissions on /etc/issue.net are configured:\e[1;32m OK \e[0m"
else
echo -e "1.8.1.6 Ensure permissions on /etc/issue.net are configured:\e[1;31m FAIL \e[0m"
fi

#1.8.2 Ensure GDM login banner is configured

comando57=$(grep banner-message-enable=true /etc/gdm3/greeter.dconf-defaults 2>&1 > /dev/null)

if [ "$comando57" == "-rw-r--r-- root root" ]; then
echo -e "1.8.2 Ensure GDM login banner is configured:\e[1;32m OK \e[0m"
else
echo -e "1.8.2 Ensure GDM login banner is configured:\e[1;31m FAIL \e[0m" 
fi

#1.9 Ensure updates, patches, and additional security software are installed

comando58=$(dnf -q check-update --security | grep '[0-9][.:][0-9]')

if [ -z "$comando58" ]; then
echo -e "1.9 Ensure updates, patches, and additional security software are installed:\e[1;32m OK \e[0m"
else
echo -e "1.9 Ensure updates, patches, and additional security software are installed:\e[1;31m FAIL \e[0m"
fi

#1.10 Ensure system-wide crypto policy is not legacy

comando59=$(grep -E -i '^\s*LEGACY\s*(\s+#.*)?$' /etc/crypto-policies/config)

if [ "$?" -eq 1 ]; then
echo -e "1.10 Ensure system-wide crypto policy is not legacy:\e[1;32m OK \e[0m"
else
echo -e "1.10 Ensure system-wide crypto policy is not legacy:\e[1;31m FAIL \e[0m"
fi

#1.11 Ensure system-wide crypto policy is FUTURE or FIPS

comando60=$(grep -E -i '^\s*(FUTURE|FIPS)\s*(\s+#.*)?$' /etc/crypto-policies/config)

if [ "$?" -eq 0 ]; then
echo -e "1.11 Ensure system-wide crypto policy is FUTURE or FIPS:\e[1;32m OK \e[0m"
else
echo -e "1.11 Ensure system-wide crypto policy is FUTURE or FIPS:\e[1;31m FAIL \e[0m"
fi

#2.1.1 Ensure xinetd is not installed

comando61=$(rpm -q xinetd)

if [ "$?" -eq 1 ]; then
echo -e "2.1.1 Ensure xinetd is not installed:\e[1;32m OK \e[0m"
else
echo -e "2.1.1 Ensure xinetd is not installed:\e[1;31m FAIL \e[0m"
fi

#2.2.1.1 Ensure time synchronization is in use

comando62=$(rpm -q chrony)

if [ "$?" -eq 0 ]; then
echo -e "2.2.1.1 Ensure time synchronization is in use:\e[1;32m OK \e[0m"
else
echo -e "2.2.1.1 Ensure time synchronization is in use:\e[1;31m FAIL \e[0m"
fi

#2.2.1.2 Ensure chrony is configured

comando63=$(timedatectl | grep 'System clock synchronized:' | awk '{print $4}')

if [ "$comando63" == "yes" ]; then
echo -e "2.2.1.2 Ensure chrony is configured:\e[1;32m OK \e[0m"
else
echo -e "2.2.1.2 Ensure chrony is configured:\e[1;31m FAIL \e[0m"
fi

#2.2.2 Ensure X Window System is not installed

comando64=$(rpm -qa xorg-x11*)

if [ "$?" -eq 1 ]; then
echo -e "2.2.2 Ensure X Window System is not installed:\e[1;32m OK \e[0m"
else
echo -e "2.2.2 Ensure X Window System is not installed:\e[1;31m FAIL \e[0m"
fi

#2.2.3 Ensure rsync service is not enabled

comando65=$(systemctl is-enabled rsyncd 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando65" == "disabled" ]; then
echo -e "2.2.3 Ensure rsync service is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.3 Ensure rsync service is not enabled:\e[1;31m FAIL \e[0m"
fi

#2.2.4 Ensure Avahi Server is not enabled

comando66=$(systemctl is-enabled avahi-daemon 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando66" == "disabled" ]; then
echo -e "2.2.4 Ensure Avahi Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.4 Ensure Avahi Server is not enabled:\e[1;31m FAIL \e[0m"
fi

#2.2.5 Ensure SNMP Server is not enabled

comando67=$(systemctl is-enabled snmpd 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando67" == "disabled" ]; then
echo -e "2.2.5 Ensure SNMP Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.5 Ensure SNMP Server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.6 Ensure HTTP Proxy Server is not enabled

comando68=$(systemctl is-enabled squid 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando68" == "disabled" ]; then
echo -e "2.2.6 Ensure HTTP Proxy Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.6 Ensure HTTP Proxy Server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.7 Ensure Samba is not enabled

comando69=$(systemctl is-enabled smb 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando69" == "disabled" ]; then
echo -e "2.2.7 Ensure Samba is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.7 Ensure Samba is not enabledd:\e[1;31m FAIL \e[0m"
fi 

#2.2.8 Ensure IMAP and POP3 server is not enabled

comando70=$(systemctl is-enabled dovecot 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando70" == "disabled" ]; then
echo -e "2.2.8 Ensure IMAP and POP3 server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.8 Ensure IMAP and POP3 server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.9 Ensure HTTP server is not enabled

comando71=$(systemctl is-enabled httpd 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando71" == "disabled" ]; then
echo -e "2.2.9 Ensure HTTP server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.9 Ensure HTTP server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.10 Ensure FTP Server is not enabled

comando72=$(systemctl is-enabled vsftpd 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando72" == "disabled" ]; then
echo -e "2.2.10 Ensure FTP Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.10 Ensure FTP Server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.11 Ensure DNS Server is not enabled 

comando73=$(systemctl is-enabled named 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando73" == "disabled" ]; then
echo -e "2.2.11 Ensure DNS Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.11 Ensure DNS Server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.12 Ensure NFS is not enabled

comando74=$(systemctl is-enabled nfs 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando74" == "disabled" ]; then
echo -e "2.2.11 Ensure DNS Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.11 Ensure DNS Server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.13 Ensure RPC is not enabled

comando75=$(systemctl is-enabled rpcbind 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando75" == "disabled" ]; then
echo -e "2.2.13 Ensure RPC is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.13 Ensure RPC is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.14 Ensure LDAP server is not enabled

comando76=$(systemctl is-enabled slapd 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando76" == "disabled" ]; then
echo -e "2.2.14 Ensure LDAP server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.14 Ensure LDAP server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.15 Ensure DHCP Server is not enabled

comando77=$(systemctl is-enabled dhcpd 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando77" == "disabled" ]; then
echo -e "2.2.15 Ensure DHCP Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.15 Ensure DHCP Server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.16 Ensure CUPS is not enabled

comando78=$(systemctl is-enabled cups 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando78" == "disabled" ]; then
echo -e "2.2.16 Ensure CUPS is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.16 Ensure CUPS is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.17 Ensure NIS Server is not enabled

comando79=$(systemctl is-enabled ypserv 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando79" == "disabled" ]; then
echo -e "2.2.17 Ensure NIS Server is not enabled:\e[1;32m OK \e[0m"
else
echo -e "2.2.17 Ensure NIS Server is not enabled:\e[1;31m FAIL \e[0m"
fi 

#2.2.18 Ensure mail transfer agent is configured for local-only mode

comando80=$(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s')

if [ -z "$comando80" ]; then
echo -e "2.2.18 Ensure mail transfer agent is configured for local-only mode:\e[1;32m OK \e[0m"
else
echo -e "2.2.18 Ensure mail transfer agent is configured for local-only mode:\e[1;31m FAIL \e[0m"
fi 

#2.3.1 Ensure NIS Client is not installed

comando81=$(rpm -q ypbind)

if [ "$?" -eq 1 ]; then
echo -e "2.3.1 Ensure NIS Client is not installed:\e[1;32m OK \e[0m"
else
echo -e "2.3.1 Ensure NIS Client is not installed:\e[1;31m FAIL \e[0m"
fi 

#2.3.2 Ensure telnet client is not installed

comando82=$(rpm -q telnet)

if [ "$?" -eq 1 ]; then
echo -e "2.3.2 Ensure telnet client is not installed:\e[1;32m OK \e[0m"
else
echo -e "2.3.2 Ensure telnet client is not installed:\e[1;31m FAIL \e[0m"
fi 

#2.3.3 Ensure LDAP client is not installed

comando83=$(rpm -q openldap-clients)

if [ "$?" -eq 1 ]; then
echo -e "2.3.3 Ensure LDAP client is not installed:\e[1;32m OK \e[0m"
else
echo -e "2.3.3 Ensure LDAP client is not installed:\e[1;31m FAIL \e[0m"
fi 

#3.1.1 Ensure IP forwarding is disabled

comando84=$(sysctl net.ipv4.ip_forward | awk '{print $3}')

if [ "$comando84" -eq 0 ]; then
echo -e "3.1.1 Ensure IP forwarding is disabled:\e[1;32m OK \e[0m"
else
echo -e "3.1.1 Ensure IP forwarding is disabled:\e[1;31m FAIL \e[0m"
fi 

#3.1.2 Ensure packet redirect sending is disabled

comando85=$(sysctl net.ipv4.conf.all.send_redirects | awk '{print $3}')
comando86=$(sysctl net.ipv4.conf.default.send_redirects | awk '{print $3}')

if [ "$comando85" -eq 0 ] && [ "$comando86" -eq 0 ]; then
echo -e "3.1.2 Ensure packet redirect sending is disabled:\e[1;32m OK \e[0m"
else
echo -e "3.1.2 Ensure packet redirect sending is disabled:\e[1;31m FAIL \e[0m"
fi 

#3.2.1 Ensure source routed packets are not accepted

comando87=$(sysctl net.ipv4.conf.all.accept_source_route | awk '{print $3}')
comando88=$(sysctl net.ipv4.conf.default.accept_source_route | awk '{print $3}')
comando89=$(sysctl net.ipv6.conf.all.accept_source_route | awk '{print $3}')
comando90=$(sysctl net.ipv6.conf.default.accept_source_route | awk '{print $3}')

if [ "$comando87" -eq 0 ] && [ "$comando88" -eq 0 ] && [ "$comando89" -eq 0 ] && [ "$comando90" -eq 0 ]; then
echo -e "3.2.1 Ensure source routed packets are not accepted:\e[1;32m OK \e[0m"
else
echo -e "3.2.1 Ensure source routed packets are not accepted:\e[1;31m FAIL \e[0m"
fi 

#3.2.2 Ensure ICMP redirects are not accepted

comando91=$(sysctl net.ipv4.conf.all.accept_redirects | awk '{print $3}')
comando92=$(sysctl net.ipv4.conf.default.accept_redirects | awk '{print $3}')
comando93=$(sysctl net.ipv4.conf.default.accept_redirects | awk '{print $3}')
comando94=$(sysctl net.ipv6.conf.default.accept_redirects | awk '{print $3}')

if [ "$comando91" -eq 0 ] && [ "$comando92" -eq 0 ] && [ "$comando93" -eq 0 ] && [ "$comando94" -eq 0 ]; then
echo -e "3.2.2 Ensure ICMP redirects are not accepted:\e[1;32m OK \e[0m"
else
echo -e "3.2.2 Ensure ICMP redirects are not accepted:\e[1;31m FAIL \e[0m"
fi 

#3.2.3 Ensure secure ICMP redirects are not accepted 

comando95=$(sysctl net.ipv4.conf.all.secure_redirects | awk '{print $3}')
comando96=$(sysctl net.ipv4.conf.default.secure_redirects | awk '{print $3}')

if [ "$comando95" -eq 0 ] && [ "$comando96" -eq 0 ]; then
echo -e "3.2.3 Ensure secure ICMP redirects are not accepted:\e[1;32m OK \e[0m"
else
echo -e "3.2.3 Ensure secure ICMP redirects are not accepted:\e[1;31m FAIL \e[0m"
fi 

#3.2.4 Ensure suspicious packets are logged

comando97=$(sysctl net.ipv4.conf.all.log_martians | awk '{print $3}')
comando98=$(sysctl net.ipv4.conf.default.log_martians | awk '{print $3}')

if [ "$comando97" -eq 1 ] && [ "$comando98" -eq 1 ]; then
echo -e "3.2.4 Ensure suspicious packets are logged:\e[1;32m OK \e[0m"
else
echo -e "3.2.4 Ensure suspicious packets are logged:\e[1;31m FAIL \e[0m"
fi 

#3.2.5 Ensure broadcast ICMP requests are ignored

comando99=$(sysctl net.ipv4.icmp_echo_ignore_broadcasts | awk '{print $3}')

if [ "$comando99" -eq 1 ]; then
echo -e "3.2.5 Ensure broadcast ICMP requests are ignored:\e[1;32m OK \e[0m"
else
echo -e "3.2.5 Ensure broadcast ICMP requests are ignored:\e[1;31m FAIL \e[0m"
fi 

#3.2.6 Ensure bogus ICMP responses are ignored

comando100=$(sysctl net.ipv4.icmp_ignore_bogus_error_responses | awk '{print $3}')

if [ "$comando100" -eq 1 ]; then
echo -e "3.2.6 Ensure bogus ICMP responses are ignored:\e[1;32m OK \e[0m"
else
echo -e "3.2.6 Ensure bogus ICMP responses are ignored:\e[1;31m FAIL \e[0m"
fi 

#3.2.7 Ensure Reverse Path Filtering is enabled

comando101=$(sysctl net.ipv4.conf.all.rp_filter | awk '{print $3}')
comando102=$(sysctl net.ipv4.conf.default.rp_filter | awk '{print $3}')

if [ "$comando101" -eq 1 ] && [ "$comando102" -eq 1 ]; then
echo -e "3.2.7 Ensure Reverse Path Filtering is enabled:\e[1;32m OK \e[0m"
else
echo -e "3.2.7 Ensure Reverse Path Filtering is enabled:\e[1;31m FAIL \e[0m"
fi 

#3.2.8 Ensure TCP SYN Cookies is enabled

comando103=$(sysctl net.ipv4.tcp_syncookies | awk '{print $3}')

if [ "$comando103" -eq 1 ]; then
echo -e "3.2.8 Ensure TCP SYN Cookies is enabled:\e[1;32m OK \e[0m"
else
echo -e "3.2.8 Ensure TCP SYN Cookies is enabled:\e[1;31m FAIL \e[0m"
fi 

#3.2.9 Ensure IPv6 router advertisements are not accepted

comando104=$(sysctl net.ipv6.conf.all.accept_ra | awk '{print $3}')
comando105=$(sysctl net.ipv6.conf.default.accept_ra | awk '{print $3}')

if [ "$comando104" -eq 0 ] && [ "$comando105" -eq 0 ]; then
echo -e "3.2.9 Ensure IPv6 router advertisements are not accepted:\e[1;32m OK \e[0m"
else
echo -e "3.2.9 Ensure IPv6 router advertisements are not accepted:\e[1;31m FAIL \e[0m"
fi 

#3.3.1 Ensure DCCP is disabled

comando106=$(lsmod | grep dccp)

if [ "$?" -eq 1 ]; then
echo -e "3.3.1 Ensure DCCP is disabled:\e[1;32m OK \e[0m"
else
echo -e "3.3.1 Ensure DCCP is disabled:\e[1;31m FAIL \e[0m"
fi 

#3.3.2 Ensure SCTP is disabled

comando107=$(lsmod | grep sctp)

if [ "$?" -eq 1 ]; then
echo -e "3.3.2 Ensure SCTP is disabled:\e[1;32m OK \e[0m"
else
echo -e "3.3.2 Ensure SCTP is disabled:\e[1;31m FAIL \e[0m"
fi 

#3.3.3 Ensure RDS is disabled

comando108=$(lsmod | grep rds)

if [ "$?" -eq 1 ]; then
echo -e "3.3.3 Ensure RDS is disabled:\e[1;32m OK \e[0m"
else
echo -e "3.3.3 Ensure RDS is disabled:\e[1;31m FAIL \e[0m"
fi 

#3.3.4 Ensure TIPC is disabled

comando109=$(lsmod | grep tipc)

if [ "$?" -eq 1 ]; then
echo -e "3.3.4 Ensure TIPC is disabled:\e[1;32m OK \e[0m"
else
echo -e "3.3.4 Ensure TIPC is disabled:\e[1;31m FAIL \e[0m"
fi 

#3.4.1 Ensure a Firewall package is installed

comando110=$(rpm -q firewalld)

if [ "$?" -eq 0 ]; then
echo -e "3.4.1 Ensure a Firewall package is installed:\e[1;32m OK \e[0m"
else
echo -e "3.4.1 Ensure a Firewall package is installed:\e[1;31m FAIL \e[0m"
fi 

#3.4.2.1 Ensure firewalld service is enabled and running

comando111=$(systemctl is-enabled firewalld 2>&1 > /dev/null)

if [ "$?" -eq 0 ] || [ "$comando111" == "enabled" ]; then
echo -e "3.4.2.1 Ensure firewalld service is enabled and running:\e[1;32m OK \e[0m"
else
echo -e "3.4.2.1 Ensure firewalld service is enabled and running:\e[1;31m FAIL \e[0m"
fi 

#3.4.2.2 Ensure iptables is not enabled

comando112=$(systemctl is-enabled iptables 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando112" == "disabled" ]; then
echo -e "3.4.2.2 Ensure iptables is not enabled:\e[1;32m OK \e[0m"
else
echo -e "3.4.2.2 Ensure iptables is not enabled:\e[1;31m FAIL \e[0m"
fi 

#3.4.2.3 Ensure nftables is not enabled

comando113=$(systemctl is-enabled nftables 2>&1 > /dev/null)

if [ "$?" -eq 1 ] || [ "$comando113" == "disabled" ]; then
echo -e "3.4.2.3 Ensure nftables is not enabled:\e[1;32m OK \e[0m"
else
echo -e "3.4.2.3 Ensure nftables is not enabled:\e[1;31m FAIL \e[0m"
fi 

#3.4.2.4 Ensure default zone is set

comando114=$(firewall-cmd --get-default-zone 2>&1 > /dev/null)

if [ "$comando114" == "public" ]; then
echo -e "3.4.2.4 Ensure default zone is set:\e[1;32m OK \e[0m"
else
echo -e "3.4.2.4 Ensure default zone is set:\e[1;31m FAIL \e[0m"
fi 

#3.4.2.5 Ensure network interfaces are assigned to appropriate zone

comando115=$(nmcli -t connection show | awk -F: '{if($4){print $4}}' | while read INT;do firewall-cmd --get-active-zones | grep -B1 $INT; done 2>&1 > /dev/null)

if [ "$?" -eq 0 ]; then
echo -e "3.4.2.5 Ensure network interfaces are assigned to appropriate zone:\e[1;32m OK \e[0m"
else
echo -e "3.4.2.5 Ensure network interfaces are assigned to appropriate zone:\e[1;31m FAIL \e[0m"
fi 

#3.4.2.6 Ensure unnecessary services and ports are not accepted

comando116=$(firewall-cmd --get-active-zones | awk '!/:/ {print $1}' | while read ZN; do firewall-cmd --list-all --zone=$ZN0; done 2>&1 > /dev/null)

if [ "$?" -eq 0 ]; then
echo -e "3.4.2.6 Ensure unnecessary services and ports are not accepted:\e[1;32m OK \e[0m"
else
echo -e "3.4.2.6 Ensure unnecessary services and ports are not accepted:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.1 Ensure iptables are flushed

comando117=$(iptables --list --line-numbers | sed '/^num\|^$\|^Chain/d' | wc -l)

if [ "$comando117" -eq 0 ]; then
echo -e "3.4.3.1 Ensure iptables are flushed:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.1 Ensure iptables are flushed:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.2 Ensure a table exists

comando118=$(nft list tables)

if [ "$?" -eq 0 ]; then
echo -e "3.4.3.2 Ensure a table exists:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.2 Ensure a table exists:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.3 Ensure base chains exist

comando119=$(nft list ruleset | grep 'hook input')
comando120=$(nft list ruleset | grep 'hook forward')
comando121=$(nft list ruleset | grep 'hook output')

if [ ! -z "$comando119" ] && [ ! -z "$comando120" ] && [ ! -z "$comando121" ]; then
echo -e "3.4.3.3 Ensure base chains exist:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.3 Ensure base chains exist:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.4 Ensure loopback traffic is configured 

comando122=$(nft list ruleset | awk '/hook input/,/}/' | grep 'iif "lo" accept')
comando123=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip sddr')
comando124=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ip6 saddr')

if [ ! -z "$comando122" ] && [ ! -z "$comando123" ] && [ ! -z "$comando124" ]; then
echo -e "3.4.3.4 Ensure loopback traffic is configured:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.4 Ensure loopback traffic is configured:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.5 Ensure outbound and established connections are configured

comando125=$(nft list ruleset | awk '/hook input/,/}/' | grep -E 'ip protocol (tcp|udp|icmp) ct state')

if [ "$?" -eq 0 ]; then
echo -e "3.4.3.5 Ensure outbound and established connections are configured:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.5 Ensure outbound and established connections are configured:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.6 Ensure default deny firewall policy

comando126=$(nft list ruleset | grep 'hook input' | grep 'policy drop')
comando127=$(nft list ruleset | grep 'hook forward' | grep 'policy drop')
comando128=$(nft list ruleset | grep 'hook output' | grep 'policy drop')

if [ ! -z "$comando126" ] && [ ! -z "$comando127" ] && [ ! -z "$comando128" ]; then
echo -e "3.4.3.6 Ensure default deny firewall policy:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.6 Ensure default deny firewall policy:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.7 Ensure nftables service is enabled

comando129=$(systemctl is-enabled nftables 2>&1 > /dev/null)

if [ "$?" -eq 0 ] || [ "$comando129" == "enabled" ]; then
echo -e "3.4.3.7 Ensure nftables service is enabled:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.7 Ensure nftables service is enabled:\e[1;31m FAIL \e[0m"
fi 

#3.4.3.8 Ensure nftables rules are permanent 

comando130=$(grep 'hook input' /etc/sysconfig/nftables.conf)
comando131=$(grep 'hook forward' /etc/sysconfig/nftables.conf)
comando132=$(grep 'hook output' /etc/sysconfig/nftables.conf)

if [ ! -z "$comando130" ] && [ ! -z  "$comando131" ] && [ ! -z "$comando132" ]; then
echo -e "3.4.3.8 Ensure nftables rules are permanent:\e[1;32m OK \e[0m"
else
echo -e "3.4.3.8 Ensure nftables rules are permanent:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.1.1 Ensure default deny firewall policy

comando133=$(iptables -L | grep Chain | egrep 'INPUT|FORWARD|OUTPUT' | grep policy | grep DROP | wc -l)

if [ "$comando133" -eq 3 ]; then
echo -e "3.4.4.1.1 Ensure default deny firewall policy:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.1.1 Ensure default deny firewall policy:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.1.2 Ensure loopback traffic is configured

comando134=$(iptables -L INPUT -v -n | grep '127.0.0.0/8')

if [ "$?" -eq 0 ]; then
echo -e "3.4.4.1.2 Ensure loopback traffic is configured:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.1.2 Ensure loopback traffic is configured:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.1.3 Ensure outbound and established connections are configured

comando135=$(iptables -L -v -n | egrep 'OUTPUT|INPUT' | grep 'NEW,ESTABLISHED')

if [ "$?" -eq 0 ]; then
echo -e "3.4.4.1.3 Ensure outbound and established connections are configured:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.1.3 Ensure outbound and established connections are configured:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.1.4 Ensure firewall rules exist for all open ports

comando136=$(for PORT in $(ss -4tuln | awk '{print $5}' | cut -d ':' -f2 | grep -v Local); do iptables -L INPUT -v -n | grep ':$PORT'; done)

if [ "$?" -eq 0 ]; then
echo -e "3.4.4.1.4 Ensure firewall rules exist for all open ports:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.1.4 Ensure firewall rules exist for all open ports:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.2.1 Ensure IPv6 default deny firewall policy

comando137=$(ip6tables -L | grep Chain | egrep 'INPUT|FORWARD|OUTPUT' | grep policy | grep DROP | wc -l)

if [ "$comando137" -eq 3 ]; then
echo -e "3.4.4.2.1 Ensure IPv6 default deny firewall policy:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.2.1 Ensure IPv6 default deny firewall policy:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.2.2 Ensure IPv6 loopback traffic is configured

comando138=$(ip6tables -L INPUT -v -n | grep '::/0')

if [ "$?" -eq 0 ]; then
echo -e "3.4.4.2.2 Ensure IPv6 loopback traffic is configured:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.2.2 Ensure IPv6 loopback traffic is configured:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.2.3 Ensure IPv6 outbound and established connections are configured

comando139=$(ip6tables -L -v -n | egrep 'OUTPUT|INPUT' | grep 'NEW,ESTABLISHED')

if [ "$?" -eq 0 ]; then
echo -e "3.4.4.2.3 Ensure IPv6 outbound and established connections are configured:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.2.3 Ensure IPv6 outbound and established connections are configured:\e[1;31m FAIL \e[0m"
fi 

#3.4.4.2.4 Ensure IPv6 firewall rules exist for all open ports

comando140=$(for PORT in $(ss -4tuln | awk '{print $5}' | cut -d ':' -f2 | grep -v Local); do ip6tables -L INPUT -v -n | grep ':$PORT'; done)

if [ "$?" -eq 0 ]; then
echo -e "3.4.4.2.4 Ensure IPv6 firewall rules exist for all open ports:\e[1;32m OK \e[0m"
else
echo -e "3.4.4.2.4 Ensure IPv6 firewall rules exist for all open ports:\e[1;31m FAIL \e[0m"
fi 

#3.6 Disable IPv6 

comando141=$(grep -E "^\s*kernelopts=(\S+\s+)*ipv6\.disable=1\b\s*(\S+\s*)*$" /boot/grub2/grubenv)

if [ "$comando141" == "ipv6.disable=1" ]; then
 echo -e "3.6 Disable IPv6 :\e[1;32m OK \e[0m"
else
echo -e "3.6 Disable IPv6 :\e[1;31m FAIL \e[0m"
fi 

#4.1.1.1 Ensure auditd is installed

comando142=$(rpm -q audit audit-libs)

if [ "$?" -eq 0 ]; then
echo -e "4.1.1.1 Ensure auditd is installed:\e[1;32m OK \e[0m"
else
echo -e "4.1.1.1 Ensure auditd is installed:\e[1;31m FAIL \e[0m"
fi 

#4.1.1.2 Ensure auditd service is enabled

comando143=$(systemctl is-enabled auditd 2>&1 > /dev/null)

if [ "$?" -eq 0 ] || [ "$comando143" == "enabled" ]; then
echo -e "4.1.1.2 Ensure auditd service is enabled:\e[1;32m OK \e[0m"
else
echo -e "4.1.1.2 Ensure auditd service is enabled:\e[1;31m FAIL \e[0m"
fi 

#4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled

comando144=$(grep -E 'kernelopts=(\S+\s+)*audit=1\b' /boot/grub2/grubenv)

if [ "$?" -eq 0 ]; then
echo -e "4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled:\e[1;32m OK \e[0m"
else
echo -e "4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled:\e[1;31m FAIL \e[0m"
fi 

#4.1.1.4 Ensure audit_backlog_limit is sufficient

comando145=$(grep -E 'kernelopts=(\S+\s+)*audit_backlog_limit=\S+\b' /boot/grub2/grubenv)

if [ "$?" -eq 0 ]; then
echo -e "4.1.1.4 Ensure audit_backlog_limit is sufficient:\e[1;32m OK \e[0m"
else
echo -e "4.1.1.4 Ensure audit_backlog_limit is sufficient:\e[1;31m FAIL \e[0m"
fi 

#4.1.2.1 Ensure audit log storage size is configured

comando146=$(grep max_log_file /etc/audit/auditd.conf)

if [ "$?" -eq 0 ]; then
echo -e "4.1.2.1 Ensure audit log storage size is configured:\e[1;32m OK \e[0m"
else
echo -e "4.1.2.1 Ensure audit log storage size is configured:\e[1;31m FAIL \e[0m"
fi 

#4.1.2.2 Ensure audit logs are not automatically deleted

comando147=$(grep max_log_file_action /etc/audit/auditd.conf | awk '{print $3}')

if [ "$comando147" == "keep_logs" ]; then
echo -e "4.1.2.2 Ensure audit logs are not automatically deleted:\e[1;32m OK \e[0m"
else
echo -e "4.1.2.2 Ensure audit logs are not automatically deleted:\e[1;31m FAIL \e[0m"
fi 

#4.1.2.3 Ensure system is disabled when audit logs are full

comando148=$(grep -w space_left_action /etc/audit/auditd.conf | awk '{print $3}')
comando149=$(grep action_mail_acct /etc/audit/auditd.conf | awk '{print $3}')
comando150=$(grep admin_space_left_action /etc/audit/auditd.conf | awk '{print $3}')

if [ "$comando148" == "email" ] && [ "$comando149" == "root" ] && [ "$comando150" == "halt" ]; then
echo -e "4.1.2.3 Ensure system is disabled when audit logs are full:\e[1;32m OK \e[0m"
else
echo -e "4.1.2.3 Ensure system is disabled when audit logs are full:\e[1;31m FAIL \e[0m"
fi 

#4.1.3 Ensure changes to system administration scope (sudoers) is collected

comando151=$(grep scope /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.3 Ensure changes to system administration scope (sudoers) is collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.3 Ensure changes to system administration scope (sudoers) is collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.4 Ensure login and logout events are collected

comando152=$(grep logins /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.4 Ensure login and logout events are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.4 Ensure login and logout events are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.5 Ensure session initiation information is collected

comando153=$(grep -E '(session|logins)' /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.5 Ensure session initiation information is collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.5 Ensure session initiation information is collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.6 Ensure events that modify date and time information are collected

comando154=$(grep time-change /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.6 Ensure events that modify date and time information are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.6 Ensure events that modify date and time information are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.7 Ensure events that modify the system's Mandatory Access Controls are collected

comando155=$(grep MAC-policy /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.7 Ensure events that modify the system's Mandatory Access Controls are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.7 Ensure events that modify the system's Mandatory Access Controls are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.8 Ensure events that modify the system's network environment are collected

comando156=$(grep system-locale /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.8 Ensure events that modify the system's network environment are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.8 Ensure events that modify the system's network environment are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.9 Ensure discretionary access control permission modification events are collected

comando157=$(auditctl -l | grep perm_mod /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.9 Ensure discretionary access control permission modification events are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.9 Ensure discretionary access control permission modification events are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.10 Ensure unsuccessful unauthorized file access attempts are collected

comando158=$(grep access /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.10 Ensure unsuccessful unauthorized file access attempts are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.10 Ensure unsuccessful unauthorized file access attempts are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.11 Ensure events that modify user/group information are collected

comando159=$(grep identity /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.11 Ensure events that modify user/group information are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.11 Ensure events that modify user/group information are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.12 Ensure successful file system mounts are collected

comando160=$(grep mounts /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.12 Ensure successful file system mounts are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.12 Ensure successful file system mounts are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.13 Ensure use of privileged commands is collected

#comando161=$()

#4.1.14 Ensure file deletion events by users are collected 

comando162=$(grep delete /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.14 Ensure file deletion events by users are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.14 Ensure file deletion events by users are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.15 Ensure kernel module loading and unloading is collected

comando163=$(grep modules /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.15 Ensure kernel module loading and unloading is collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.15 Ensure kernel module loading and unloading is collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.16. Ensure system administrator actions (sudolog) are collected

comando164=$(grep -E "^\s*-w\s+$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//')\s+-p\s+wa\s+-k\s+actions" /etc/audit/rules.d/*.rules)

if [ "$?" -eq 0 ]; then
echo -e "4.1.16. Ensure system administrator actions (sudolog) are collected:\e[1;32m OK \e[0m"
else
echo -e "4.1.16. Ensure system administrator actions (sudolog) are collected:\e[1;31m FAIL \e[0m"
fi 

#4.1.17 Ensure the audit configuration is immutable

comando165=$(grep "^\s*[^#]" /etc/audit/rules.d/*.rules | tail -1)

if [ "$comando165" == "-e 2" ]; then
echo -e "4.1.17 Ensure the audit configuration is immutable:\e[1;32m OK \e[0m"
else
echo -e "4.1.17 Ensure the audit configuration is immutable:\e[1;31m FAIL \e[0m"
fi 

#4.2.1.1 Ensure rsyslog is installed

comando166=$(rpm -q rsyslog)

if [ "$?" -eq 0 ]; then
echo -e "4.2.1.1 Ensure rsyslog is installed:\e[1;32m OK \e[0m"
else
echo -e "4.2.1.1 Ensure rsyslog is installed:\e[1;31m FAIL \e[0m"
fi 

#4.2.1.2 Ensure rsyslog Service is enabled

comando167=$(systemctl is-enabled rsyslog 2>&1 > /dev/null)

if [ "$?" -eq 0 ] || [ "$comando167" == "enabled" ]; then
echo -e "4.2.1.2 Ensure rsyslog Service is enabled:\e[1;32m OK \e[0m"
else
echo -e "4.2.1.2 Ensure rsyslog Service is enabled:\e[1;31m FAIL \e[0m"
fi 

#4.2.1.3 Ensure rsyslog default file permissions configured

comando168=$(grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>&1 > /dev/null)

if [ "$?" -eq 0 ]; then
echo -e "4.2.1.3 Ensure rsyslog default file permissions configured:\e[1;32m OK \e[0m"
else
echo -e "4.2.1.3 Ensure rsyslog default file permissions configured:\e[1;31m FAIL \e[0m"
fi 

#4.2.1.4 Ensure logging is configured

#comando169=$()

#4.2.1.5 Ensure rsyslog is configured to send logs to a remote log host

comando170=$(grep "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>&1 > /dev/null)

if [ "$?" -eq 0 ]; then
echo -e "4.2.1.5 Ensure rsyslog is configured to send logs to a remote log host:\e[1;32m OK \e[0m"
else
echo -e "4.2.1.5 Ensure rsyslog is configured to send logs to a remote log host:\e[1;31m FAIL \e[0m"
fi 

#4.2.1.6 Ensure remote rsyslog messages are only accepted on designated log hosts

comando171=$(grep '$ModLoad imtcp' /etc/rsyslog.conf 2>&1 > /dev/null)
comando172=$(grep '$InputTCPServerRun 514' /etc/rsyslog.conf 2>&1 > /dev/null)

if [ ! -z "$comando171" ] && [ ! -z "$comando172" ]; then
echo -e "4.2.1.6 Ensure remote rsyslog messages are only accepted on designated log hosts:\e[1;32m OK \e[0m"
else
echo -e "4.2.1.6 Ensure remote rsyslog messages are only accepted on designated log hosts:\e[1;31m FAIL \e[0m"
fi 

#4.2.2.1 Ensure journald is configured to send logs to rsyslog

comando173=$(grep -e ^\s*ForwardToSyslog /etc/systemd/journald.conf)

if [ "$comando173" == "ForwardToSyslog=yes" ]; then
echo -e "4.2.2.1 Ensure journald is configured to send logs to rsyslog:\e[1;32m OK \e[0m"
else
echo -e "4.2.2.1 Ensure journald is configured to send logs to rsyslog:\e[1;31m FAIL \e[0m"
fi 

#4.2.2.2 Ensure journald is configured to compress large log files

comando174=$(grep -e ^\s*Compress /etc/systemd/journald.conf)

if [ "$comando174" == "Compress=yes" ]; then
echo -e "4.2.2.2 Ensure journald is configured to compress large log files:\e[1;32m OK \e[0m"
else
echo -e "4.2.2.2 Ensure journald is configured to compress large log files:\e[1;31m FAIL \e[0m"
fi 

#4.2.2.3 Ensure journald is configured to write logfiles to persistent disk

comando175=$(grep -e ^\s*Storage /etc/systemd/journald.conf)

if [ "$comando175" == "Storage=persistent" ]; then
echo -e "4.2.2.3 Ensure journald is configured to write logfiles to persistent disk:\e[1;32m OK \e[0m"
else
echo -e "4.2.2.3 Ensure journald is configured to write logfiles to persistent disk:\e[1;31m FAIL \e[0m"
fi 

#4.2.3 Ensure permissions on all logfiles are configured

comando176=$(find /var/log -name "prueba.txt.*" -type f -perm /037 -ls -o -type d -perm /026 -ls | wc -l)

if [ "$comando176" -eq 0 ]; then
echo -e "4.2.3 Ensure permissions on all logfiles are configured:\e[1;32m OK \e[0m"
else
echo -e "4.2.3 Ensure permissions on all logfiles are configured:\e[1;31m FAIL \e[0m"
fi 

#4.3 Ensure logrotate is configured

#5.1.1 Ensure cron daemon is enabled

comando177=$(systemctl is-enabled crond 2>&1 > /dev/null)

if [ "$?" -eq 0 ] || [ "$comando177" == "enabled" ]; then
echo -e "5.1.1 Ensure cron daemon is enabled:\e[1;32m OK \e[0m"
else
echo -e "5.1.1 Ensure cron daemon is enabled:\e[1;31m FAIL \e[0m"
fi 

#5.1.2 Ensure permissions on /etc/crontab are configured

comando178=$(stat /etc/crontab | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando178" == "-rw------- root root" ]; then
echo -e "5.1.2 Ensure permissions on /etc/crontab are configured:\e[1;32m OK \e[0m"
else
echo -e "5.1.2 Ensure permissions on /etc/crontab are configured:\e[1;31m FAIL \e[0m"
fi 

#5.1.3 Ensure permissions on /etc/cron.hourly are configured

comando179=$(stat /etc/cron.hourly | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando179" == "drwx------ root root" ]; then
echo -e "5.1.3 Ensure permissions on /etc/cron.hourly are configured:\e[1;32m OK \e[0m"
else
echo -e "5.1.3 Ensure permissions on /etc/cron.hourly are configured:\e[1;31m FAIL \e[0m"
fi 

#5.1.4 Ensure permissions on /etc/cron.daily are configured

comando180=$(stat /etc/cron.daily | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando180" == "drwx------ root root" ]; then
echo -e "5.1.4 Ensure permissions on /etc/cron.daily are configured:\e[1;32m OK \e[0m"
else
echo -e "5.1.4 Ensure permissions on /etc/cron.daily are configured:\e[1;31m FAIL \e[0m"
fi 

#5.1.5 Ensure permissions on /etc/cron.weekly are configured

comando181=$(stat /etc/cron.weekly | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando181" == "drwx------ root root" ]; then
echo -e "5.1.5 Ensure permissions on /etc/cron.weekly are configured:\e[1;32m OK \e[0m"
else
echo -e "5.1.5 Ensure permissions on /etc/cron.weekly are configured:\e[1;31m FAIL \e[0m"
fi 

#5.1.6 Ensure permissions on /etc/cron.monthly are configured

comando182=$(stat /etc/cron.monthly | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando182" == "drwx------ root root" ]; then
echo -e "5.1.6 Ensure permissions on /etc/cron.monthly are configured:\e[1;32m OK \e[0m"
else
echo -e "5.1.6 Ensure permissions on /etc/cron.monthly are configured:\e[1;31m FAIL \e[0m"
fi 

#5.1.7 Ensure permissions on /etc/cron.d are configured

comando183=$(stat /etc/cron.d | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando183" == "drwx------ root root" ]; then
echo -e "5.1.7 Ensure permissions on /etc/cron.d are configured:\e[1;32m OK \e[0m"
else
echo -e "5.1.7 Ensure permissions on /etc/cron.d are configured:\e[1;31m FAIL \e[0m"
fi 

#5.1.8 Ensure at/cron is restricted to authorized users

comando184=/etc/cron.allow

if [ -f "$comando184" ]; then
echo -e "5.1.8 Ensure at/cron is restricted to authorized users:\e[1;32m OK \e[0m"
else
echo -e "5.1.8 Ensure at/cron is restricted to authorized users:\e[1;31m FAIL \e[0m"
fi 

#5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured

comando185=$(stat /etc/ssh/sshd_config | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando185" == "-rw------- root root" ]; then
echo -e "5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured:\e[1;32m OK \e[0m"
else
echo -e "5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured:\e[1;31m FAIL \e[0m"
fi 

#5.2.2 Ensure SSH access is limited

comando186=$(sshd -T | grep -E '^\s*(allow|deny)(users|groups)\s+\S+' | wc -l)

if [ "$comando186" -gt 0 ]; then
echo -e "5.2.2 Ensure SSH access is limited:\e[1;32m OK \e[0m"
else
echo -e "5.2.2 Ensure SSH access is limited:\e[1;31m FAIL \e[0m"
fi 

#5.2.3 Ensure permissions on SSH private host key files are configured

comando187=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec stat {} \; | grep Access | grep Uid | awk '{print $2, $6}' | cut -d '/' -f2 | sed 's/)//g' | sort -u)
comando188=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec stat {} \; | grep Access | grep Uid | awk '{print $2, $6}' | cut -d '/' -f2 | sed 's/)//g' | sort -u | wc -l)

if [ "$comando187" == "-rw------- root" ] && [ "$comando188" -eq 1 ]; then
echo -e "5.2.3 Ensure permissions on SSH private host key files are configured:\e[1;32m OK \e[0m"
else
echo -e "5.2.3 Ensure permissions on SSH private host key files are configured:\e[1;31m FAIL \e[0m"
fi 

#5.2.4 Ensure permissions on SSH public host key files are configured

comando189=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec stat {} \; | grep Access | grep Uid | awk '{print $2, $6}' | cut -d '/' -f2 | sed 's/)//g' | sort -u)
comando190=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec stat {} \; | grep Access | grep Uid | awk '{print $2, $6}' | cut -d '/' -f2 | sed 's/)//g' | sort -u | wc -l)

if [ "$comando189" == "-rw------- root" ] && [ "$comando190" -eq 1 ]; then
echo -e "5.2.4 Ensure permissions on SSH public host key files are configured:\e[1;32m OK \e[0m"
else
echo -e "5.2.4 Ensure permissions on SSH public host key files are configured:\e[1;31m FAIL \e[0m"
fi 

#5.2.5 Ensure SSH LogLevel is appropriate

comando191=$(sshd -T | grep -i loglevel | awk '{print $2}')

if [ "$comando191" == "VERBOSE" ] || [ "$comando191" == "INFO" ]; then
echo -e "5.2.5 Ensure SSH LogLevel is appropriate:\e[1;32m OK \e[0m"
else
echo -e "5.2.5 Ensure SSH LogLevel is appropriate:\e[1;31m FAIL \e[0m"
fi

#5.2.6 Ensure SSH X11 forwarding is disabled

comando192=$(sshd -T | grep -i x11forwarding | awk '{print $2}')

if [ "$comando192" == "no" ] || [ "$comando192" == "NO" ]; then
echo -e "5.2.6 Ensure SSH X11 forwarding is disabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.6 Ensure SSH X11 forwarding is disabled:\e[1;31m FAIL \e[0m"
fi

#5.2.7 Ensure SSH MaxAuthTries is set to 4 or less

comando193=$(sshd -T | grep -i maxauthtries | awk '{print $2}')

if [ "$comando193" -le 4 ]; then
echo -e "5.2.7 Ensure SSH MaxAuthTries is set to 4 or less:\e[1;32m OK \e[0m"
else
echo -e "5.2.7 Ensure SSH MaxAuthTries is set to 4 or less:\e[1;31m FAIL \e[0m"
fi

#5.2.8 Ensure SSH IgnoreRhosts is enabled

comando194=$(sshd -T | grep -i ignorerhosts | awk '{print $2}')

if [ "$comando194" == "yes" ] || [ "$comando194" == "YES" ]; then
echo -e "5.2.8 Ensure SSH IgnoreRhosts is enabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.8 Ensure SSH IgnoreRhosts is enabled:\e[1;31m FAIL \e[0m"
fi

#5.2.9 Ensure SSH HostbasedAuthentication is disabled

comando195=$(sshd -T | grep -i hostbasedauthentication | awk '{print $2}')

if [ "$comando195" == "no" ] || [ "$comando195" == "NO" ]; then
echo -e "5.2.9 Ensure SSH HostbasedAuthentication is disabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.9 Ensure SSH HostbasedAuthentication is disabled:\e[1;31m FAIL \e[0m"
fi

#5.2.10 Ensure SSH root login is disabled

comando196=$(sshd -T | grep -i permitrootlogin | awk '{print $2}')

if [ "$comando196" == "no" ] || [ "$comando196" == "NO" ]; then
echo -e "5.2.10 Ensure SSH root login is disabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.10 Ensure SSH root login is disabled:\e[1;31m FAIL \e[0m"
fi

#5.2.11 Ensure SSH PermitEmptyPasswords is disabled

comando197=$(sshd -T | grep -i permitemptypasswords | awk '{print $2}')

if [ "$comando197" == "no" ] || [ "$comando197" == "NO" ]; then
echo -e "5.2.11 Ensure SSH PermitEmptyPasswords is disabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.11 Ensure SSH PermitEmptyPasswords is disabled:\e[1;31m FAIL \e[0m"
fi

#5.2.12 Ensure SSH PermitUserEnvironment is disabled

comando198=$(sshd -T | grep -i permituserenvironment | awk '{print $2}')

if [ "$comando198" == "no" ] || [ "$comando198" == "NO" ]; then
echo -e "5.2.12 Ensure SSH PermitUserEnvironment is disabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.12 Ensure SSH PermitUserEnvironment is disabled:\e[1;31m FAIL \e[0m"
fi

#5.2.13 Ensure SSH Idle Timeout Interval is configured

comando199=$(sshd -T | grep -i clientaliveinterval | awk '{print $2}')
comando200=$(sshd -T | grep -i clientalivecountmax | awk '{print $2}')

if [ "$comando199" -gt 1 ] && [ "$comando199" -le 300 ] && [ "$comando200" -gt 0 ] && [ "$comando200" -le 3 ]; then
echo -e "5.2.13 Ensure SSH Idle Timeout Interval is configured:\e[1;32m OK \e[0m"
else
echo -e "5.2.13 Ensure SSH Idle Timeout Interval is configured:\e[1;31m FAIL \e[0m"
fi

#5.2.14 Ensure SSH LoginGraceTime is set to one minute or less

comando201=$(sshd -T | grep -i logingracetime | awk '{print $2}')

if [ "$comando201" -ge 1 ] && [ "$comando201" -le 60 ]; then
echo -e "5.2.14 Ensure SSH LoginGraceTime is set to one minute or less:\e[1;32m OK \e[0m"
else
echo -e "5.2.14 Ensure SSH LoginGraceTime is set to one minute or less:\e[1;31m FAIL \e[0m"
fi

#5.2.15 Ensure SSH warning banner is configured

comando202=$(sshd -T | grep -i banner | awk '{print $2}')

if [ "$comando202" == "/etc/issue.net" ]; then
echo -e "5.2.15 Ensure SSH warning banner is configured:\e[1;32m OK \e[0m"
else
echo -e "5.2.15 Ensure SSH warning banner is configured:\e[1;31m FAIL \e[0m"
fi

#5.2.16 Ensure SSH PAM is enabled

comando203=$(sshd -T | grep -i usepam | awk '{print $2}')

if [ "$comando203" == "yes" ] || [ "$comando203" == "YES" ]; then
echo -e "5.2.16 Ensure SSH PAM is enabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.16 Ensure SSH PAM is enabled:\e[1;31m FAIL \e[0m"
fi

#5.2.17 Ensure SSH AllowTcpForwarding is disabled

comando204=$(sshd -T | grep -i allowtcpforwarding | awk '{print $2}')

if [ "$comando204" == "no" ] || [ "$comando204" == "NO" ]; then
echo -e "5.2.17 Ensure SSH AllowTcpForwarding is disabled:\e[1;32m OK \e[0m"
else
echo -e "5.2.17 Ensure SSH AllowTcpForwarding is disabled:\e[1;31m FAIL \e[0m"
fi

#5.2.18 Ensure SSH MaxStartups is configured

comando205=$(sshd -T | grep -i maxstartups | awk '{print $2}')

if [ "$comando205" == "10:30:60" ]; then
echo -e "5.2.18 Ensure SSH MaxStartups is configured:\e[1;32m OK \e[0m"
else
echo -e "5.2.18 Ensure SSH MaxStartups is configured:\e[1;31m FAIL \e[0m"
fi

#5.2.19 Ensure SSH MaxSessions is set to 4 or less

comando206=$(sshd -T | grep -i maxsessions | awk '{print $2}')

if [ "$comando206" -le 4 ]; then
echo -e "5.2.19 Ensure SSH MaxSessions is set to 4 or less:\e[1;32m OK \e[0m"
else
echo -e "5.2.19 Ensure SSH MaxSessions is set to 4 or less:\e[1;31m FAIL \e[0m"
fi

#5.2.20 Ensure system-wide crypto policy is not over-ridden

comando207=$(grep '^/s*CRYPTO_POLICY=' /etc/sysconfig/sshd)

if [ "$?" -eq 0 ]; then
echo -e "5.2.10 Ensure system-wide crypto policy is not over-ridden:\e[1;32m OK \e[0m"
else
echo -e "5.2.10 Ensure system-wide crypto policy is not over-ridden:\e[1;31m FAIL \e[0m"
fi

#5.3.1 Create custom authselect profile

comando208=$(authselect current | grep 'Profile ID:')

if [ "$?" -eq 0 ]; then
echo -e "5.3.1 Create custom authselect profile:\e[1;32m OK \e[0m"
else
echo -e "5.3.1 Create custom authselect profile:\e[1;31m FAIL \e[0m"
fi

#5.3.2 Select authselect profile

comando209=$(authselect current)

if [ "$?" -eq 0 ]; then
echo -e "5.3.2 Select authselect profile:\e[1;32m OK \e[0m"
else
echo -e "5.3.2 Select authselect profile:\e[1;31m FAIL \e[0m"
fi

#5.3.3 Ensure authselect includes with-faillock

comando210=$(authselect current | grep with-faillock)

if [ "$?" -eq 0 ]; then
echo -e "5.3.3 Ensure authselect includes with-faillock:\e[1;32m OK \e[0m"
else
echo -e "5.3.3 Ensure authselect includes with-faillock:\e[1;31m FAIL \e[0m"
fi

#5.4.1 Ensure password creation requirements are configured

comando211=$(grep pam_pwquality.so /etc/pam.d/system-auth /etc/pam.d/password-auth | wc -l)
comando212=$(grep ^minlen /etc/security/pwquality.conf | wc -l)
comando213=$(grep ^minclass /etc/security/pwquality.conf | wc -l)

if [ "$comando211" -eq 2 ] && [ "$comando212" -gt 0 ] && [ "$comando213" -gt 0 ]; then
echo -e "5.4.1 Ensure password creation requirements are configured:\e[1;32m OK \e[0m"
else
echo -e "5.4.1 Ensure password creation requirements are configured:\e[1;31m FAIL \e[0m"
fi

#5.4.2 Ensure lockout for failed password attempts is configured

comando214=$(grep -E '^\s*auth\s+required\s+pam_faillock.so\s+' /etc/pam.d/password-auth /etc/pam.d/system-auth)

if [ "$?" -eq 0 ]; then
echo -e "5.4.2 Ensure lockout for failed password attempts is configured:\e[1;32m OK \e[0m"
else
echo -e "5.4.2 Ensure lockout for failed password attempts is configured:\e[1;31m FAIL \e[0m"
fi

#5.4.3 Ensure password reuse is limited

comando215=$(grep -E '^\s*password\s+(requisite|sufficient)\s+(pam_pwquality\.so|pam_unix\.so)\s+.*remember=([5-9]|[1-4][0-9])[0-9]*\s*.*$' /etc/pam.d/system-auth)

if [ "$?" -eq 0 ]; then
echo -e "5.4.3 Ensure password reuse is limited:\e[1;32m OK \e[0m"
else
echo -e "5.4.3 Ensure password reuse is limited:\e[1;31m FAIL \e[0m"
fi

#5.4.4 Ensure password hashing algorithm is SHA-512

comando216=$(grep -E '^\s*password\s+sufficient\s+pam_unix.so\s+.*sha512\s*.*$' /etc/pam.d/password-auth /etc/pam.d/system-auth)

if [ "$?" -eq 0 ]; then
echo -e "5.4.4 Ensure password hashing algorithm is SHA-512:\e[1;32m OK \e[0m"
else
echo -e "5.4.4 Ensure password hashing algorithm is SHA-512:\e[1;31m FAIL \e[0m"
fi

#5.5.1.1 Ensure password expiration is 365 days or less

comando217=$(grep PASS_MAX_DAYS /etc/login.defs | grep -v '#' | awk '{print $2}')

if [ "$comando217" -le 365 ]; then
echo -e "5.5.1.1 Ensure password expiration is 365 days or less:\e[1;32m OK \e[0m"
else
echo -e "5.5.1.1 Ensure password expiration is 365 days or less:\e[1;31m FAIL \e[0m"
fi

#5.5.1.2 Ensure minimum days between password changes is 7 or more

comando218=$(grep PASS_MIN_DAYS /etc/login.defs | grep -v '#' | awk '{print $2}')

if [ "$comando218" -ge 7 ]; then
echo -e "5.5.1.1 Ensure password expiration is 365 days or less:\e[1;32m OK \e[0m"
else
echo -e "5.5.1.1 Ensure password expiration is 365 days or less:\e[1;31m FAIL \e[0m"
fi

#5.5.1.3 Ensure password expiration warning days is 7 or more

comando219=$(grep PASS_WARN_AGE /etc/login.defs | grep -v '#' | awk '{print $2}')

if [ "$comando219" -ge 7 ]; then
echo -e "5.5.1.3 Ensure password expiration warning days is 7 or more:\e[1;32m OK \e[0m"
else
echo -e "5.5.1.3 Ensure password expiration warning days is 7 or more:\e[1;31m FAIL \e[0m"
fi

#5.5.1.4 Ensure inactive password lock is 30 days or less

comando220=$(useradd -D | grep INACTIVE)

if [ "$comando220" == "INACTIVE=30" ]; then
echo -e "5.5.1.4 Ensure inactive password lock is 30 days or less:\e[1;32m OK \e[0m"
else
echo -e "5.5.1.4 Ensure inactive password lock is 30 days or less:\e[1;31m FAIL \e[0m"
fi

#5.5.1.5 Ensure all users last password change date is in the past

#comando221=$()

#5.5.2 Ensure system accounts are secured

comando222=$(awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000)' /etc/passwd | awk -F':' '{print $7}' | sort -u)
comando223=$(awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000)' /etc/passwd | awk -F':' '{print $7}' | sort -u | wc -l)

if [ "$comando222" == "/sbin/nologin" ] && [ "$comando223" -eq 1 ] ; then
echo -e "5.5.2 Ensure system accounts are secured:\e[1;32m OK \e[0m"
else
echo -e "5.5.2 Ensure system accounts are secured:\e[1;31m FAIL \e[0m"
fi

#5.5.3 Ensure default user shell timeout is 900 seconds or less

comando224=$(grep "^TMOUT" /etc/profile /etc/profile.d/*.sh /etc/bashrc)

if [ "$?" -eq 0 ] ; then
echo -e "5.5.3 Ensure default user shell timeout is 900 seconds or less:\e[1;32m OK \e[0m"
else
echo -e "5.5.3 Ensure default user shell timeout is 900 seconds or less:\e[1;31m FAIL \e[0m"
fi

#5.5.4 Ensure default group for the root account is GID 0

comando225=$(grep "^root:" /etc/passwd | cut -f4 -d:)

if [ "$comando225" -eq 0 ] ; then
echo -e "5.5.4 Ensure default group for the root account is GID 0:\e[1;32m OK \e[0m"
else
echo -e "5.5.4 Ensure default group for the root account is GID 0:\e[1;31m FAIL \e[0m"
fi

#5.5.5 Ensure default user umask is 027 or more restrictive

comando226=$(grep "umask" /etc/profile /etc/profile.d/*.sh /etc/bashrc | grep -v '#' | awk '{print $2,$3}' | grep 'umask 027' | sort -u | wc -l)

if [ "$comando225" -eq 1 ] ; then
echo -e "5.5.5 Ensure default user umask is 027 or more restrictive:\e[1;32m OK \e[0m"
else
echo -e "5.5.5 Ensure default user umask is 027 or more restrictive:\e[1;31m FAIL \e[0m"
fi

#5.6 Ensure root login is restricted to system console

#5.7 Ensure access to the su command is restricted

comando227=$(grep pam_wheel.so /etc/pam.d/su | grep -v '#')

if [ "$?" -eq 0 ] ; then
echo -e "5.7 Ensure access to the su command is restricted:\e[1;32m OK \e[0m"
else
echo -e "5.7 Ensure access to the su command is restricted:\e[1;31m FAIL \e[0m"
fi

#6.1.1 Audit system file permissions

#6.1.2 Ensure permissions on /etc/passwd are configured

comando229=$(stat /etc/passwd | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando229" == "-rw-r--r-- root root" ]; then
echo -e "6.1.2 Ensure permissions on /etc/passwd are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.2 Ensure permissions on /etc/passwd are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.3 Ensure permissions on /etc/shadow are configured

comando230=$(stat /etc/passwd | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando230" == "-rw-r----- root root" ]; then
echo -e "6.1.3 Ensure permissions on /etc/shadow are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.3 Ensure permissions on /etc/shadow are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.4 Ensure permissions on /etc/group are configured

comando231=$(stat /etc/group | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando231" == "-rw-r--r-- root root" ]; then
echo -e "6.1.4 Ensure permissions on /etc/group are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.4 Ensure permissions on /etc/group are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.5 Ensure permissions on /etc/gshadow are configured

comando232=$(stat /etc/gshadow | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando232" == "-rw-r----- root root" ]; then
echo -e "6.1.5 Ensure permissions on /etc/gshadow are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.5 Ensure permissions on /etc/gshadow are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.6 Ensure permissions on /etc/passwd- are configured

comando233=$(stat /etc/passwd- | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando233" == "-rw-r--r-- root root" ]; then
echo -e "6.1.6 Ensure permissions on /etc/passwd- are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.6 Ensure permissions on /etc/passwd- are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.7 Ensure permissions on /etc/shadow- are configured

comando234=$(stat /etc/shadow- | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando234" == "-rw------- root root" ]; then
echo -e "6.1.7 Ensure permissions on /etc/shadow- are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.7 Ensure permissions on /etc/shadow- are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.8 Ensure permissions on /etc/group- are configured

comando235=$(stat /etc/group- | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando235" == "-rw-r--r-- root root" ]; then
echo -e "6.1.8 Ensure permissions on /etc/group- are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.8 Ensure permissions on /etc/group- are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.9 Ensure permissions on /etc/gshadow- are configured

comando236=$(stat /etc/gshadow- | grep Access | head -1 | awk '{print $2, $6, $10}' | cut -d '/' -f2 | cut -d ')' -f1,2,3 | sed 's/)//g')

if [ "$comando236" == "-rw-r----- root root" ]; then
echo -e "6.1.9 Ensure permissions on /etc/gshadow- are configured:\e[1;32m OK \e[0m"
else
echo -e "6.1.9 Ensure permissions on /etc/gshadow- are configured:\e[1;31m FAIL \e[0m"
fi

#6.1.10 Ensure no world writable files exist 

comando237=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002 -print 2>/dev/null | wc -l)

if [ "$comando237" -eq 0 ]; then
echo -e "6.1.10 Ensure no world writable files exist:\e[1;32m OK \e[0m"
else
echo -e "6.1.10 Ensure no world writable files exist:\e[1;31m FAIL \e[0m"
fi

#6.1.11 Ensure no unowned files or directories exist

comando238=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nouser -print 2>/dev/null | wc -l)

if [ "$comando238" -eq 0 ]; then
echo -e "6.1.11 Ensure no unowned files or directories exist:\e[1;32m OK \e[0m"
else
echo -e "6.1.11 Ensure no unowned files or directories exist:\e[1;31m FAIL \e[0m"
fi

#6.1.12 Ensure no ungrouped files or directories exist

comando239=$(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup -print 2>/dev/null | wc -l)

if [ "$comando239" -eq 0 ]; then
echo -e "6.1.12 Ensure no ungrouped files or directories exist:\e[1;32m OK \e[0m"
else
echo -e "6.1.12 Ensure no ungrouped files or directories exist:\e[1;31m FAIL \e[0m"
fi

#6.1.13 Audit SUID executables

#comando240

#6.1.14 Audit SGID executables

#comando241

#6.2.1 Ensure password fields are not empty

comando242=$(awk -F: '($2 == "!!" ) { print $1 " does not have a password "}' /etc/shadow | wc -l)

if [ "$comando242" -eq 0 ]; then
echo -e "6.2.1 Ensure password fields are not empty:\e[1;32m OK \e[0m"
else
echo -e "6.2.1 Ensure password fields are not empty:\e[1;31m FAIL \e[0m"
fi

#6.2.2 Ensure no legacy "+" entries exist in /etc/passwd

comando243=$(grep '^\+:' /etc/passwd | wc -l)

if [ "$comando243" -eq 0 ]; then
echo -e "6.2.2 Ensure no legacy "+" entries exist in /etc/passwd:\e[1;32m OK \e[0m"
else
echo -e "6.2.2 Ensure no legacy "+" entries exist in /etc/passwd:\e[1;31m FAIL \e[0m"
fi

#6.2.3 Ensure root PATH Integrity

cat /dev/null > /tmp/PATH.txt

for x in $(echo $PATH | tr ":" " ") ; do
 if [ -d "$x" ] ; then
 ls -ldH "$x" | awk '
$9 == "." {print "PATH contains current working directory (.)"}
$3 != "root" {print $9, "is not owned by root"}
substr($1,6,1) != "-" {print $9, "is group writable"}
substr($1,9,1) != "-" {print $9, "is world writable"}'
 else
 echo "$x is not a directory" >> /tmp/PATH.txt
 fi
done

if [ $(cat /tmp/PATH.txt | wc -l) -eq 0 ]; then
echo -e "6.2.3 Ensure root PATH Integrity:\e[1;32m OK \e[0m"
else
echo -e "6.2.3 Ensure root PATH Integrity:\e[1;31m FAIL \e[0m"
fi

#6.2.4 Ensure no legacy "+" entries exist in /etc/shadow

comando244=$(grep '^\+:' /etc/shadow | wc -l)

if [ "$comando244" -eq 0 ]; then
echo -e "6.2.4 Ensure no legacy "+" entries exist in /etc/shadow:\e[1;32m OK \e[0m"
else
echo -e "6.2.4 Ensure no legacy "+" entries exist in /etc/shadow:\e[1;31m FAIL \e[0m"
fi

#6.2.5 Ensure no legacy "+" entries exist in /etc/group

comando245=$(grep '^\+:' /etc/group | wc -l)

if [ "$comando245" -eq 0 ]; then
echo -e "6.2.5 Ensure no legacy "+" entries exist in /etc/group:\e[1;32m OK \e[0m"
else
echo -e "6.2.5 Ensure no legacy "+" entries exist in /etc/group:\e[1;31m FAIL \e[0m"
fi

#6.2.6 Ensure root is the only UID 0 account

comando246=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd | wc -l)

if [ "$comando246" -eq 1 ]; then
echo -e "6.2.6 Ensure root is the only UID 0 account:\e[1;32m OK \e[0m"
else
echo -e "6.2.6 Ensure root is the only UID 0 account:\e[1;31m FAIL \e[0m"
fi

#6.2.7 Ensure users' home directories permissions are 750 or more restrictive

comando247=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/sbin/nologin") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 dirperm=$(ls -ld $dir | cut -f1 -d" ")
 if [ $(echo $dirperm | cut -c6) != "-" ]; then
 echo "Group Write permission set on the home directory ($dir) of user 
$user"
 fi
 if [ $(echo $dirperm | cut -c8) != "-" ]; then
 echo "Other Read permission set on the home directory ($dir) of user 
$user"
 fi
 if [ $(echo $dirperm | cut -c9) != "-" ]; then
 echo "Other Write permission set on the home directory ($dir) of user 
$user"
 fi
 if [ $(echo $dirperm | cut -c10) != "-" ]; then
 echo "Other Execute permission set on the home directory ($dir) of user 
$user"
 fi
 fi
done | wc -l)

if [ "$comando247" -eq 0 ]; then
echo -e "6.2.7 Ensure users' home directories permissions are 750 or more restrictive:\e[1;32m OK \e[0m"
else
echo -e "6.2.7 Ensure users' home directories permissions are 750 or more restrictive:\e[1;31m FAIL \e[0m"
fi

#6.2.8 Ensure users own their home directories

comando248=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/sbin/nologin") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 owner=$(stat -L -c "%U" "$dir")
 if [ "$owner" != "$user" ]; then
 echo "The home directory ($dir) of user $user is owned by $owner."
 fi
fi
done | wc -l)

if [ "$comando248" -eq 0 ]; then
echo -e "6.2.8 Ensure users own their home directories:\e[1;32m OK \e[0m"
else
echo -e "6.2.8 Ensure users own their home directories:\e[1;31m FAIL \e[0m"
fi

#6.2.9 Ensure users' dot files are not group or world writable

comando249=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/sbin/nologin") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 for file in $dir/.[A-Za-z0-9]*; do
 if [ ! -h "$file" -a -f "$file" ]; then
 fileperm=$(ls -ld $file | cut -f1 -d" ")
 if [ $(echo $fileperm | cut -c6) != "-" ]; then
 echo "Group Write permission set on file $file"
 fi
 if [ $(echo $fileperm | cut -c9) != "-" ]; then
 echo "Other Write permission set on file $file"
 fi
 fi
 done
 fi
done | wc -l)

if [ "$comando249" -eq 0 ]; then
echo -e "6.2.9 Ensure users' dot files are not group or world writable:\e[1;32m OK \e[0m"
else
echo -e "6.2.9 Ensure users' dot files are not group or world writable:\e[1;31m FAIL \e[0m"
fi

#6.2.10 Ensure no users have .forward files

comando250=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/sbin/nologin") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 if [ ! -h "$dir/.forward" -a -f "$dir/.forward" ]; then
 echo ".forward file $dir/.forward exists"
 fi
 fi
done | wc -l)

if [ "$comando250" -eq 0 ]; then
echo -e "6.2.10 Ensure no users have .forward files:\e[1;32m OK \e[0m"
else
echo -e "6.2.10 Ensure no users have .forward files:\e[1;31m FAIL \e[0m"
fi

#6.2.11 Ensure no users have .netrc files

comando251=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 if [ ! -h "$dir/.netrc" -a -f "$dir/.netrc" ]; then
 echo ".netrc file $dir/.netrc exists"
 fi
 fi
done | wc -l)

if [ "$comando251" -eq 0 ]; then
echo -e "6.2.11 Ensure no users have .netrc files:\e[1;32m OK \e[0m"
else
echo -e "6.2.11 Ensure no users have .netrc files:\e[1;31m FAIL \e[0m"
fi

#6.2.12 Ensure users' .netrc Files are not group or world accessible

comando252=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/sbin/nologin") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 for file in $dir/.netrc; do
 if [ ! -h "$file" -a -f "$file" ]; then
 fileperm=$(ls -ld $file | cut -f1 -d" ")
 if [ $(echo $fileperm | cut -c5) != "-" ]; then
 echo "Group Read set on $file"
 fi
 if [ $(echo $fileperm | cut -c6) != "-" ]; then
 echo "Group Write set on $file"
 fi
 if [ $(echo $fileperm | cut -c7) != "-" ]; then
 echo "Group Execute set on $file"
 fi
 if [ $(echo $fileperm | cut -c8) != "-" ]; then
 echo "Other Read set on $file"
 fi
 if [ $(echo $fileperm | cut -c9) != "-" ]; then
 echo "Other Write set on $file"
 fi
 if [ $(echo $fileperm | cut -c10) != "-" ]; then
 echo "Other Execute set on $file"
 fi
 fi
 done
 fi
done | wc -l)

if [ "$comando252" -eq 0 ]; then
echo -e "6.2.12 Ensure users' .netrc Files are not group or world accessible:\e[1;32m OK \e[0m"
else
echo -e "6.2.12 Ensure users' .netrc Files are not group or world accessible:\e[1;31m FAIL \e[0m"
fi

#6.2.13 Ensure no users have .rhosts files

comando253=$(grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/sbin/nologin") { print $1 " " $6 }' | while read user dir; do
 if [ ! -d "$dir" ]; then
 echo "The home directory ($dir) of user $user does not exist."
 else
 for file in $dir/.rhosts; do
 if [ ! -h "$file" -a -f "$file" ]; then
 echo ".rhosts file in $dir"
 fi
 done
 fi
done | wc -l)

if [ "$comando253" -eq 0 ]; then
echo -e "6.2.13 Ensure no users have .rhosts files:\e[1;32m OK \e[0m"
else
echo -e "6.2.13 Ensure no users have .rhosts files:\e[1;31m FAIL \e[0m"
fi

#6.2.14 Ensure all groups in /etc/passwd exist in /etc/group

comando254=$(for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
 grep -q -P "^.*?:[^:]*:$i:" /etc/group
 if [ $? -ne 0 ]; then
 echo "Group $i is referenced by /etc/passwd but does not exist in 
/etc/group"
 fi
done | wc -l)

if [ "$comando254" -eq 0 ]; then
echo -e "6.2.14 Ensure all groups in /etc/passwd exist in /etc/group:\e[1;32m OK \e[0m"
else
echo -e "6.2.14 Ensure all groups in /etc/passwd exist in /etc/group:\e[1;31m FAIL \e[0m"
fi

#6.2.15 Ensure no duplicate UIDs exist

comando255=$(cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do
 [ -z "$x" ] && break
 set - $x
 if [ $1 -gt 1 ]; then
 users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
 echo "Duplicate UID ($2): $users"
 fi
done | wc -l)

if [ "$comando255" -eq 0 ]; then
echo -e "6.2.15 Ensure no duplicate UIDs exist:\e[1;32m OK \e[0m"
else
echo -e "6.2.15 Ensure no duplicate UIDs exist:\e[1;31m FAIL \e[0m"
fi

#6.2.16 Ensure no duplicate GIDs exist

comando256=$(cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
 echo "Duplicate GID ($x) in /etc/group"
done | wc -l)

if [ "$comando256" -eq 0 ]; then
echo -e "6.2.16 Ensure no duplicate GIDs exist:\e[1;32m OK \e[0m"
else
echo -e "6.2.16 Ensure no duplicate GIDs exist:\e[1;31m FAIL \e[0m"
fi

#6.2.17 Ensure no duplicate user names exist

comando257=$(cut -d: -f1 /etc/passwd | sort | uniq -d | while read x ; do
 echo "Duplicate login name ${x} in /etc/passwd"
done | wc -l)

if [ "$comando257" -eq 0 ]; then
echo -e "6.2.17 Ensure no duplicate user names exist:\e[1;32m OK \e[0m"
else
echo -e "6.2.17 Ensure no duplicate user names exist:\e[1;31m FAIL \e[0m"
fi

#6.2.18 Ensure no duplicate group names exist

comando258=$(cut -d: -f1 /etc/group | sort | uniq -d | while read x ; do
 echo "Duplicate group name ${x} in /etc/group"
done | wc -l)

if [ "$comando258" -eq 0 ]; then
echo -e "6.2.18 Ensure no duplicate group names exist:\e[1;32m OK \e[0m"
else
echo -e "6.2.18 Ensure no duplicate group names exist:\e[1;31m FAIL \e[0m"
fi

#6.2.19 Ensure shadow group is empty

comando259=$(grep ^shadow:[^:]*:[^:]*:[^:]+ /etc/group | wc -l)

if [ "$comando259" -eq 0 ]; then
echo -e "6.2.19 Ensure shadow group is empty:\e[1;32m OK \e[0m"
else
echo -e "6.2.19 Ensure shadow group is emptyt:\e[1;31m FAIL \e[0m"
fi

#6.2.20 Ensure all users' home directories exist

comando260=$(grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/sbin/nologin") { print $1 " " $6 }' | while read -r user dir; do
if [ ! -d "$dir" ]; then
echo "The home directory ($dir) of user $user does not exist."
fi
done | wc -l)

if [ "$comando260" -eq 0 ]; then
echo -e "6.2.20 Ensure all users' home directories exist:\e[1;32m OK \e[0m"
else
echo -e "6.2.20 Ensure all users' home directories existt:\e[1;31m FAIL \e[0m"
fi
