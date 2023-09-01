#!/bin/bash
cd /tmp
source ./password.txt
TMPINSTALL="Agent-Core-AIX-20.0.0-1540.powerpc.bff.gz"
if gunzip -f $TMPINSTALL; then
 if test -f ${TMPINSTALL%.gz}; then
   sudo installp -a -d ${TMPINSTALL%.gz} ds_agent
   sleep 5
   sudo /opt/ds_agent/dsa_control -a 'dsm://agents.deepsecurity.trendmicro.com:443/' "tenantID:$tenantID" "token:$token" "policyid:1"
   sleep 5
 fi
fi
