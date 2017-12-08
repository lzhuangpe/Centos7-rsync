#!/bin/bash

Version=rsync-3.1.2
Passwd=backup

yum install -y gcc-c++
wget https://download.samba.org/pub/rsync/rsync-3.1.2.tar.gz
tar -zxf $Version.tar.gz && cd $Version
./configure
make && make install

echo "$Passwd" >>/etc/rsyncd.passwd
chmod 600 /etc/rsyncd.passwd
