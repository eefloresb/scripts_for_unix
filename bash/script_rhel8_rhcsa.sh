################################
### Creating th LAB - script ###
################################
# Lines thast you need to change before run the script
# Line 19: Put your IP address
# Line 20: Put your hostname
# Line 21: Put your short hostname
# Line 22: Put your domain
# Line 23: Put your realm
# Line 24: Put your ldap home directory for the ldap users
# Line 42: Put your reverse-zone ip address
# Line 106: Fixing resolv.conf
# Line 164-166: Check your network device and ip address
# Line 168: Check the path to your local repository
# Line 174: Check the config repo lines (hostname)

#!/bin/sh
## Loading Variables
IP_ADDR=192.168.20.10
HOSTNAME=rhel8beta.labrhel.com
SHORTNAME=rhel8beta
DOMAIN=labrhel.com
REALM=LABRHEL.COM
LDAPHOME=/home/ldap

## Starting and Enabling Firewalld
systemctl enable firewalld ; systemctl start firewalld

## Masquerade the Network
firewall-cmd --add-masquerade --permanent; firewall-cmd --reload

## Install IPA Server and Others tools
yum module list idm
yum module info idm:DL1
yum -y install @idm:DL1
yum install -y ipa-server ipa-server-dns bind-dyndb-ldap

## Setting the right config on hosts file
echo "$IP_ADDR $HOSTNAME $SHORTNAME" >> /etc/hosts

# Installing everything unattended
ipa-server-install --domain=$DOMAIN --realm=$REALM --ds-password=password --admin-password=password --hostname=$HOSTNAME --ip-address=$IP_ADDR --reverse-zone=20.168.192.in-addr.arpa. --forwarder=8.8.8.8 --allow-zone-overlap --setup-dns --unattended

# Opening ports
for i in http https ldap ldaps kerberos kpasswd dns ntp; do firewall-cmd --permanent --add-service $i; done
firewall-cmd --reload

# FTP installation
# yum install -y vsftpd
# systemctl enable vsftpd ; systemctl start vsftpd

# firewall-cmd --add-service ftp --permanent; firewall-cmd --reload

## CA cert
# cp /root/cacert.p12 /var/ftp/pub
# cp /etc/ipa/ca.crt /var/ftp/pub

# Kerberos ticket for the rest of the configuration
echo -n 'password' | kinit admin

# Changing default home directory on new user
ipa config-mod --homedirectory=$LDAPHOME

# Configuring NFS
yum -y install nfs-utils

systemctl enable rpcbind ; systemctl enable nfs-server
systemctl start rpcbind ; systemctl start nfs-server

mkdir $LDAPHOME
mkdir /srv/nfs
chown nobody /srv/nfs

mkdir -p /srv/indirect/{oeste,centro,este}
mkdir -p /srv/direct/externo

echo "$LDAPHOME *(rw)" >> /etc/exports
echo "/srv/nfs *(rw)" >> /etc/exports

echo "/srv/direct/externo *(rw)" >> /etc/exports
echo "hola mundo direct" > /srv/direct/externo/direct_file.txt

echo "/srv/indirect *(rw)" >> /etc/exports
echo "oeste" > /srv/indirect/oeste/oeste_file.txt
echo "este" > /srv/indirect/este/este_file.txt
echo "centro" > /srv/indirect/centro/centro_file.txt


# echo "/srv/indirect/oeste *(rw)" >> /etc/exports
# echo "/srv/indirect/centro *(rw)" >> /etc/exports
# echo "/srv/indirect/este *(rw)" >> /etc/exports

chown -R nobody /srv/direct
chown -R nobody /srv/indirect
exportfs -vr

# Firewall Change for NFS
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=nfs
firewall-cmd --reload

cd $LDAPHOME
mkdir ldapuser{1..5}

# Creating LDAP users
ipa user-add ldapuser1 --first=ldapuser1 --last=ldapuser1
ipa user-add ldapuser2 --first=ldapuser2 --last=ldapuser2
ipa user-add ldapuser3 --first=ldapuser3 --last=ldapuser3
ipa user-add ldapuser4 --first=ldapuser4 --last=ldapuser4
ipa user-add ldapuser5 --first=ldapuser5 --last=ldapuser5

echo 'password' | ipa passwd ldapuser1
echo 'password' | ipa passwd ldapuser2
echo 'password' | ipa passwd ldapuser3
echo 'password' | ipa passwd ldapuser4
echo 'password' | ipa passwd ldapuser5

chown ldapuser1 ldapuser1
chown ldapuser2 ldapuser2
chown ldapuser3 ldapuser3
chown ldapuser4 ldapuser4
chown ldapuser5 ldapuser5

# Fixing resolv.conf
# sed -i 's/nameserver 127.0.0.1/nameserver 192.168.20.XXX/' /etc/resolv.conf

# Samba Configuration
mkdir /srv/samba
chmod 2775 /srv/samba
mkdir /srv/public
chmod 777 /srv/public


touch /srv/samba/samba-user-1
touch /srv/samba/samba-user-2
touch /srv/samba/samba-user-3

# Creating the group
groupadd userssamba
chown -R :userssamba /srv/samba

# Installing Samba
yum -y install samba
systemctl enable smb
systemctl enable nmb

# Creating usernames
useradd sambauser1 -G userssamba
printf "password\npassword\n" | smbpasswd -a -s sambauser1

useradd sambauser2 -G userssamba
printf "password\npassword\n" | smbpasswd -a -s sambauser2

useradd sambauser3 -G userssamba
printf "password\npassword\n" | smbpasswd -a -s sambauser3

# Firewall for Samba
firewall-cmd --add-service samba --permanent
firewall-cmd --reload

# Editing the smb.conf
echo "[data]" >> /etc/samba/smb.conf
echo "comment = data share" >> /etc/samba/smb.conf
echo "path = /srv/samba" >> /etc/samba/smb.conf
echo "write list = @userssamba" >> /etc/samba/smb.conf

sed -i '/\[global\]/a map to guest = bad user' /etc/samba/smb.conf

echo "[public]" >> /etc/samba/smb.conf
echo "comment = Public Directory" >> /etc/samba/smb.conf
echo "path = /srv/public" >> /etc/samba/smb.conf
echo "browseable = yes" >> /etc/samba/smb.conf
echo "writable = yes" >> /etc/samba/smb.conf
echo "guest ok = yes" >> /etc/samba/smb.conf
echo "read only = no" >> /etc/samba/smb.conf

semanage fcontext -a -t samba_share_t "/srv/samba(/.*)?"
semanage fcontext -a -t samba_share_t "/srv/public(/.*)?"
restorecon -Rv /srv

systemctl restart smb
systemctl restart nmb

# nmcli connection modify eth0 ipv4.dns 192.168.20.10
# nmcli connection down eth0
# nmcli connection up eth0

# Creating Network repo
mkdir -p /var/www/html/repos
#cp -a /mnt/iso /var/ftp/pub/repos/rhel8
cp -a /mnt /var/www/html/repos/rhel8
restorecon -Rvv /var/www/html

# Creating Base Repo File - base
## BaseOS and AppStream:
echo "[base]" >> /var/www/html/repos/base.repo
echo "name = Base Reporitory for RHEL 8" >> /var/www/html/repos/base.repo
echo "baseurl = http://SERVER_NAME.labrhel.com/repos/rhel8/BaseOS" >> /var/www/html/repos/base.repo
echo "enabled = 0" >> /var/www/html/repos/base.repo
echo "gpgcheck = 0" >> /var/www/html/repos/base.repo

echo "[appstream]" >> /var/www/html/repos/base.repo
echo "name = App Stream Reporitory for RHEL 8" >> /var/www/html/repos/base.repo
echo "baseurl = http://SERVER_NAME.labrhel.com/repos/rhel8/AppStream" >> /var/www/html/repos/base.repo
echo "enabled = 0" >> /var/www/html/repos/base.repo
echo "gpgcheck = 0" >> /var/www/html/repos/base.repo

# systemctl restart vsftpd
