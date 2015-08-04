#!/bin/bash

lvs_keepalived_base=$(cd `dirname $0`; pwd)
. ${lvs_keepalived_base}/conf/lvs-keepalived.conf

### 获取服务器ip
self_ips=`ifconfig | grep 'inet '| grep -v '127.0.0.1' | awk '{ print $2}'`
self_ip=`echo ${self_ips} | awk '{ print $1}'`

echo "本机ip：${self_ip}"

self_state="realserver"

### 判断服务器角色
if [ "${self_ip}" = "${dr_server_ips[0]}" ]; then
    self_state="master"
else
    for ((i=1;i<${#dr_server_ips[*]};i++));do
#        echo "${dr_server_ips[${i}]}"
        if [ "${self_ip}" = "${dr_server_ips[${i}]}" ]; then
            self_state="backup"
        fi
    done
fi
echo "初始化${self_state}配置"
if [ "${self_state}" = "realserver" ]; then
    
    . ${lvs_keepalived_base}/conf/real_server_init.sh
else
    . ${lvs_keepalived_base}/conf/dr_init.sh
fi

chmod a+x *
