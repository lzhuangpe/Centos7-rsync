#!/bin/bash

Passwd=backup

yum install -y rsync
echo "$Passwd" >>/etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd
