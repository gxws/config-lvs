guide-lvs-keepalived
====================


lvs+keepalived负载均衡和主机检测教程

lvs+keepalived集群由master-backup方式实现，由keepalived负责失效检测和自动切换。


安装ipvsadm和keepalived
需要root权限
yum install ipvsadm keepalived

新建路径/home/lvs-keepalived/


在nginx运行的服务器上运行real_server/startup.sh

在lvs master服务器上运行dr_master/init.sh初始化配置

运行dr_master/startup.sh启动

在lvs backup服务器上运行dr_master/init.sh初始化配置

运行dr_backup/startup.sh启动


realserver配置文件放在conf/virtualserver文件夹中，格式需要按照已有配置进行
