
echo ${self_stats}" startup.sh脚本初始化"

startup_file=${lvs_keepalived_base}/startup.sh
if [ -e ${startup_file} ];then
   rm -f ${startup_file}
fi

echo "#!/bin/bash" > ${startup_file}
echo ". /etc/rc.d/init.d/functions" >> ${startup_file}
echo "systemctl start keepalived.service" >> ${startup_file}
echo "/sbin/ipvsadm --set 30 5 60" >> ${startup_file}

count=0
for conf_file in ${lvs_keepalived_base}/virtualserver/* ;do
    . ${conf_file}
    echo "/sbin/ifconfig ${interface}:${count} ${vip} netmask 255.255.255.255 broadcast ${vip} up" >> ${startup_file}
    echo "/sbin/route add -host ${vip} dev ${interface}:${count}" >> ${startup_file}
    echo "/sbin/ipvsadm -A -t ${vip}:${vport} -s wrr -p 5" >> ${startup_file}
    count=`expr ${count} + 1`
    for ((i=0;i<${#real_server_ips[*]};i++));do
        echo "/sbin/ipvsadm -a -t ${vip}:${vport} -r ${real_server_ips[${i}]}:${real_server_ports[${i}]} -g -w 1" >> ${startup_file}
    done
done

echo "touch /var/lock/subsys/ipvsadm >/dev/null 2>&1" >> ${startup_file}
echo ${self_stats}" startup.sh脚本初始化完成"