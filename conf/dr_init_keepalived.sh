echo "初始化keepalived配置文件"
keepalived_conf_file=/etc/keepalived/keepalived.conf

### 备份keepalived配置
if [ -e ${keepalived_conf_file} ]; then
    mv ${keepalived_conf_file} /etc/keepalived/keepalived.conf.bakeup.`date "+%Y%m%d%H%M%S"`
fi

### 从模板写入keepalived配置
cat ${lvs_keepalived_base}/template/keepalived.conf.global.template >> ${keepalived_conf_file}

for conf_file in ${lvs_keepalived_base}/virtualserver/* ;do
    . ${conf_file}
    cat ${lvs_keepalived_base}/template/keepalived.conf.vrrp.template >> ${keepalived_conf_file}
    cat ${lvs_keepalived_base}/template/keepalived.conf.virtualserver.template >> ${keepalived_conf_file}

    vrrp_instance=`echo ${conf_file##*/} | cut -d '.' -f 1`
    sed -i -e 's/\$vrrp_instance/'"${vrrp_instance}"'/g' ${keepalived_conf_file}
    virtual_router_id=`echo ${vrrp_instance} | cut -d '_' -f 2`
    sed -i -e 's/\$virtual_router_id/'"${virtual_router_id}"'/g' ${keepalived_conf_file}
    
    sed -i -e 's/\$vip/'"${vip}"'/g' ${keepalived_conf_file}
    sed -i -e 's/\$vport/'"${vport}"'/g' ${keepalived_conf_file}
    sed -i -e 's/\$interface/'"${interface}"'/g' ${keepalived_conf_file}

    sed -i -e 's/\$state/'"${self_state}"'/g' ${keepalived_conf_file}
    if [ "${self_state}" = "backup" ];then
        last_ip_number=`echo ${self_ip} | cut -d '.' -f 4 `
        sed -i -e 's/\$priority/'"${last_ip_number}"'/g' ${keepalived_conf_file}
    else
        sed -i -e 's/\$priority/256/g' ${keepalived_conf_file}
    fi
    
    sed -i -e 's/\$vip/'"${vip}"'/g' ${keepalived_conf_file}
    for ((i=0;i<${#real_server_ips[*]};i++));do
        cat ${lvs_keepalived_base}/template/keepalived.conf.virtualserver.realserver.template >> ${keepalived_conf_file}
        sed -i -e 's/\$real_server_ip/'"${real_server_ips[${i}]}"'/g' ${keepalived_conf_file}
        sed -i -e 's/\$real_server_port/'"${real_server_ports[${i}]}"'/g' ${keepalived_conf_file}
    done
    sed -i -e '$a }' ${keepalived_conf_file}
done

echo "keepalived配置文件初始化完成"