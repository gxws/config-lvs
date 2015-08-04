
shutdown_file=${lvs_keepalived_base}/shutdown.sh
if [ -e ${shutdown_file} ];then
   rm -f ${shutdown_file}
fi

echo "#!/bin/bash" > ${shutdown_file}
echo ". /etc/rc.d/init.d/functions" >> ${shutdown_file}

count=0
for conf_file in ${lvs_keepalived_base}/virtualserver/*;do
    . ${conf_file}
    for ((i=0;i<${#real_server_ips[*]};i++));do
        if [ "${self_ip}" = "${real_server_ips[${i}]}" ]; then
            echo "/sbin/ifconfig lo:${count} down" >> ${shutdown_file}
            echo "route del ${vip} >/dev/null 2>&1" >> ${shutdown_file}
            count=`expr ${count} + 1`
        fi
    done
done

echo 'echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore' >> ${shutdown_file}
echo 'echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce' >> ${shutdown_file}
echo 'echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore' >> ${shutdown_file}
echo 'echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce' >> ${shutdown_file}