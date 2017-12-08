#!/bin/bash

User=backup
Passwd=backup
BackPath=/backup

yum install -y rsync

echo "$User:$Passwd" >>/etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd

mkdir -p $BackPath

cat > /etc/rsyncd.conf << EOF
# /etc/rsyncd: configuration file for rsync daemon mode

# See rsyncd.conf man page for more options.

# configuration example:

uid = root
gid = root
max connections = 5
timeout = 600
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsync.log

[backup]
path = /backup
auth users = backup
secrets file = /etc/rsyncd.passwd
#hosts allow = 192.168.1.0/24
#hosts deny = *
read only = no
use chroot = no
list = no
ignore errors
EOF

systemctl enable rsyncd && systemctl start rsyncd
