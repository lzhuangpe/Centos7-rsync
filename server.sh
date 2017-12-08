#!/bin/bash

Version=rsync-3.1.2
User=backup
Passwd=backup
BackPath=/backup

yum install -y gcc-c++
wget https://download.samba.org/pub/rsync/rsync-3.1.2.tar.gz
tar -zxf $Version.tar.gz && cd $Version
./configure
make && make install

echo "$User:$Passwd" >>/etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd

mkdir -p /$BackPath
chown -R nobody:nobody $BackPath

cat > /etc/rsyncd.conf << EOF
# /etc/rsyncd: configuration file for rsync daemon mode

# See rsyncd.conf man page for more options.

# configuration example:

uid = nobody                        #运行rsync的用户
gid = nobody                        #运行rsync的用户
use chroot = no                     #不允许切换目录
max connections = 5                 #最大连接数
timeout = 600                       #超时时间
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsync.log
ignore errors                       #忽略错误
read only = false                   #设置可写
list = false                        #不允许显示列表
hosts allow = 172.16.100.0/24       #允许访问的IP
hosts deny = *                      #拒绝所有IP访问
auth users = rsync_backup           #同步的虚拟用户名
secrets file = /etc/rsync.passwd    #虚拟用户密码

[backup]
path = /backup
EOF

systemctl enable rsyncd && systemctl start rsyncd
