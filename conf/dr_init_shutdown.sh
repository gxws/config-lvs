
echo ${self_stats}" shutdown.sh脚本初始化"

shutdown_file=${lvs_keepalived_base}/shutdown.sh
if [ -e ${shutdown_file} ];then
   rm -f ${shutdown_file}
fi

echo "#!/bin/bash" > ${shutdown_file}
echo ". /etc/rc.d/init.d/functions" >> ${shutdown_file}
echo "systemctl stop keepalived.service" >> ${shutdown_file}
echo "/sbin/ipvsadm -C" >> ${shutdown_file}
echo "/sbin/ipvsadm -Z" >> ${shutdown_file}

count=0
for conf_file in ${lvs_keepalived_base}/virtualserver/* ;do
    echo "/sbin/ifconfig ${interface}:${count} down" >> ${shutdown_file}
    echo "/sbin/route del ${vip}" >> ${shutdown_file}
    count=`expr ${count} + 1`
done

echo "rm -rf /var/lock/subsys/ipvsadm >/dev/null 2>&1" >> ${shutdown_file}
echo ${self_stats}" shutdown.sh脚本初始化完成"
