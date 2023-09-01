#!/bin/bash


__smb_info(){
#### extract resources from smb.conf 
if [[ -f /etc/samba/smb.conf ]]; then
    local resources=""
    cat /etc/samb/smb.conf | grep -Eo "\[[[:alpha:]]+\]"
fi
}

__get_service(){
  local service=$1
  if [[ $service == sshd ]]; then 
    __sshd_info
  elif [[ $service == smb ]]; then
    __smb_info
  else 
    __nfs-server info
  fi

}

__main_(){

  for i in smb sshd nfs-server; do
    if systemctl is-active $i; then
        __get_service $i
    fi
  done

}
