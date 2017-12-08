#!/bin/bash

User=backup
Passwd=backup
BackPath=/backup

yum install -y rsync

echo "$User:$Passwd" >>/etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd

mkdir -p /$BackPath

cat > /etc/rsyncd.conf << EOF
# /etc/rsyncd: configuration file for rsync daemon mode

# See rsyncd.conf man page for more options.

# configuration example:

uid = root
gid = root
max connections = 5                     #最大连接数
timeout = 600                           #超时时间
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsync.log

[backup]
path = /backup
auth users = backup                     #同步的虚拟用户名
secrets file = /etc/rsyncd.passwd       #虚拟用户密码文件
hosts allow = 192.168.1.0/24            #允许访问的IP
hosts deny = *                          #拒绝所有IP访问
read only =  false                      #设置可写
use chroot = false                      #不允许切换目录
list = false                            #不允许显示列表
ignore = errors                         #忽略错误
EOF

echo "/usr/bin/rsync --daemon" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
/usr/bin/rsync --daemon

