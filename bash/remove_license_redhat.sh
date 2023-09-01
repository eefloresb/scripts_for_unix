#!/bin/bash
source password.source
subscription-manager remove --all
subscription-manager unregister
subscription-manager clean
yum remove -y katello*
rm -rfv /etc/yum.repos.d/redhat.repo
sleep 5
subscription-manager register --username  $username --password $password --auto-attach --force
yum clean all
yum update -y 
