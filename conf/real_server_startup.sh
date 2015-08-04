
startup_file=${lvs_keepalived_base}/startup.sh
if [ -e ${startup_file} ];then
   rm -f ${startup_file}
fi

echo "#!/bin/bash" > ${startup_file}
echo ". /etc/rc.d/init.d/functions" >> ${startup_file}

count=0
for conf_file in ${lvs_keepalived_base}/virtualserver/*;do
    . ${conf_file}
    for ((i=0;i<${#real_server_ips[*]};i++));do
        if [ "${self_ip}" = "${real_server_ips[${i}]}" ]; then
            echo "/sbin/ifconfig lo:${count} ${vip} broadcast ${vip} netmask 255.255.255.255 up" >> ${startup_file}
            echo "/sbin/route add -host ${vip} dev lo:${count}" >> ${startup_file}
            count=`expr ${count} + 1`
        fi
    done
done

echo 'echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore' >> ${startup_file}
echo 'echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce' >> ${startup_file}
echo 'echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore' >> ${startup_file}
echo 'echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce' >> ${startup_file}
echo "sysctl -p >/dev/null 2>&1" >> ${startup_file}